using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Sockets;
using System.Collections;
using System.Threading;
using NetWorkLib.Interfaces;
using log4net;
using System.Reflection;
using Jsion.NetWork.Sockets;
using Jsion.NetWork.Packet;
using JsionFramework.Jsion.Utils;

namespace Jsion.NetWork.Processors
{
    public class PackageProcessor
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static readonly byte[] POLICY = Encoding.UTF8.GetBytes("<?xml version=\"1.0\"?><!DOCTYPE cross-domain-policy SYSTEM \"http://www.adobe.com/xml/dtds/cross-domain-policy.dtd\"><cross-domain-policy><allow-access-from domain=\"*\" to-ports=\"*\" /></cross-domain-policy>\0");

        private bool policy = false;

        protected Queue m_pkgQueue;

        protected bool m_sendingTcp;

        protected ByteSocket m_socket;

        protected byte[] m_sendBuffer;
        protected byte[] m_receiveBuffer;

        protected int m_firstPkgOffset = 0;
        protected int m_sendedLength = 0;
        protected int packageBuffSize = 0;

        protected SocketAsyncEventArgs m_sendAsyncEvent;
        protected SocketAsyncEventArgs m_receiveAsyncEvent;

        //protected IPackageReader pkgReader;

        public PackageProcessor(ByteSocket socket)
        {
            // TODO: Complete member initialization

            m_sendBuffer = new byte[m_socket.SendBufferSize];
            m_receiveBuffer = new byte[m_socket.ReceiveBufferSize];

            Init(socket);

            AsyncReceiveImp();
        }

        public PackageProcessor(ByteSocket socket, byte[] sBuffer, byte[] rBuffer)
        {
            // TODO: Complete member initialization

            m_sendBuffer = sBuffer;
            m_receiveBuffer = rBuffer;

            Init(socket);

            AsyncReceiveImp();
        }

        protected virtual void Init(ByteSocket socket)
        {
            m_sendingTcp = false;
            m_pkgQueue = new Queue(256);

            //pkgReader = new PackageReader();

            m_socket = socket;

            m_sendAsyncEvent = new SocketAsyncEventArgs();
            m_sendAsyncEvent.UserToken = this;
            m_sendAsyncEvent.SetBuffer(m_sendBuffer, 0, 0);
            m_sendAsyncEvent.Completed += new EventHandler<SocketAsyncEventArgs>(AsyncSendPkgComplete);

            m_receiveAsyncEvent = new SocketAsyncEventArgs();
            m_receiveAsyncEvent.Completed += new EventHandler<SocketAsyncEventArgs>(AsyncReceiveComplete);
        }

        private static void SendAsyncImp(object state)
        {
            PackageProcessor proc = state as PackageProcessor;
            ByteSocket s = proc.m_socket;

            try
            {
                AsyncSendPkgComplete(s.Sockets, proc.m_sendAsyncEvent);
            }
            catch (Exception ex)
            {
                log.Error("Async send package error.", ex);
                s.Disconnect();
            }
        }

        private static void AsyncSendPkgComplete(object sender, SocketAsyncEventArgs e)
        {
            PackageProcessor proc = (PackageProcessor)e.UserToken;
            ByteSocket sock = proc.m_socket;
            try
            {
                Queue q = proc.m_pkgQueue;
                if (q == null || !sock.Sockets.Connected) return;
                int sent = e.BytesTransferred;
                byte[] data = proc.m_sendBuffer;
                int count = proc.m_sendedLength - sent;

                if (count > 0) Array.Copy(data, sent, data, 0, count);
                else count = 0;

                e.SetBuffer(0, 0);

                int firstOffset = proc.m_firstPkgOffset;

                lock (q.SyncRoot)
                {
                    while (q.Count > 0)
                    {
                        Package pkg = (Package)q.Peek();

                        int len = 0;

                        if (sock.Encryted)
                        {
                            len = pkg.CopyToEncryt(data, count, firstOffset, sock.PackageCrytor);
                        }
                        else
                        {
                            len = pkg.CopyTo(data, count, firstOffset);
                        }

                        firstOffset += len;
                        count += len;

                        if (pkg.dataLength <= firstOffset)
                        {
                            q.Dequeue();
                            firstOffset = 0;
                            sock.PackageCrytor.EncrytOnceComplete();
                        }

                        if (data.Length == count)
                        {
                            break;
                        }
                    }

                    proc.m_firstPkgOffset = firstOffset;

                    if (count <= 0)
                    {
                        proc.m_sendingTcp = false;
                        return;
                    }
                }

                proc.m_sendedLength = count;
                e.SetBuffer(0, count);
                if (sock.Sockets.SendAsync(e)) return;
                AsyncSendPkgComplete(sender, e);
            }
            catch (Exception ex)
            {
                log.Error("Async sending package error.", ex);
                sock.Disconnect();
            }
        }

        private void AsyncReceiveImp()
        {
            if (m_socket != null && m_socket.Sockets != null && m_socket.Sockets.Connected)
            {
                if (packageBuffSize >= m_receiveBuffer.Length)
                {
                    log.Error("无可用缓冲区来接收数据.");
                    m_socket.Disconnect();
                }
                else
                {
                    m_receiveAsyncEvent.SetBuffer(m_receiveBuffer, packageBuffSize, m_receiveBuffer.Length - packageBuffSize);
                    if (!m_socket.Sockets.ReceiveAsync(m_receiveAsyncEvent))
                    {
                        AsyncReceiveComplete(m_socket.Sockets, m_receiveAsyncEvent);
                    }
                }
            }
        }

        private void AsyncReceiveComplete(object sender, SocketAsyncEventArgs e)
        {
            try
            {
                lock (this)
                {
                    if (policy == false && m_receiveBuffer[0] == '<')
                    {
                        policy = true;
                        m_socket.Sockets.Send(POLICY);
                        return;
                    }

                    if (e.BytesTransferred > 0)
                    {
                        #region ParseBuffer

                        int bufferSize = packageBuffSize + e.BytesTransferred;
                        if (bufferSize < Package.HDR_SIZE)
                        {
                            packageBuffSize = bufferSize;
                            return;
                        }

                        packageBuffSize = 0;

                        int curOffset = 0;
                        int dataLeft = bufferSize;

                        int packageLength = 0;
                        int header = 0;

                        while (dataLeft >= Package.HDR_SIZE)
                        {
                            packageLength = 0;

                            if (m_socket.Encryted)
                            {
                                while (curOffset + 4 < bufferSize)
                                {
                                    header = m_socket.PackageCrytor.Decryt(m_receiveBuffer[curOffset]) << 8;
                                    header += m_socket.PackageCrytor.Decryt(m_receiveBuffer[curOffset + 1]);

                                    if ((short)header == Package.HEADER)
                                    {
                                        packageLength = m_socket.PackageCrytor.Decryt(m_receiveBuffer[curOffset + 2]) << 8;
                                        packageLength += m_socket.PackageCrytor.Decryt(m_receiveBuffer[curOffset + 3]);
                                        break;
                                    }
                                    else
                                    {
                                        curOffset++;
                                    }
                                }
                            }
                            else
                            {
                                while (curOffset + 4 < bufferSize)
                                {
                                    header = m_receiveBuffer[curOffset] << 8;
                                    header += m_receiveBuffer[curOffset + 1];
                                    if ((short)header == Package.HEADER)
                                    {
                                        packageLength = m_receiveBuffer[curOffset + 2] << 8;
                                        packageLength += m_receiveBuffer[curOffset + 3];
                                        break;
                                    }
                                    else
                                    {
                                        curOffset++;
                                    }
                                }
                            }

                            dataLeft = bufferSize - curOffset;

                            if ((packageLength != 0 && packageLength < Package.HDR_SIZE) || packageLength > m_socket.ReceiveBufferSize)
                            {
                                log.ErrorFormat("读取的数据包长：{0}  包头长：{1}  读取时的当前游标：{2}  当前总数据流长度：{3}  当前收到数据流长度：{4}  来自：{5}", packageLength, Package.HDR_SIZE, curOffset, bufferSize, e.BytesTransferred, m_socket.RemoteEndPoint);
                                log.Error(Marshal.ToHexDump("=======================包数据==========================", m_receiveBuffer));
                                if (m_socket.Strict)
                                {
                                    packageBuffSize = 0;
                                    m_socket.Disconnect();
                                    return;//严格模式则释放并退出
                                }
                                m_socket.PackageCrytor.DecrytOnceComplete();
                                continue;//继续解析后面的数据包
                            }

                            Package pkg = null;// = pkgReader.ReadPackage(ref curOffset, ref packageLength, bufferSize, m_receiveBuffer, m_socket);

                            if (dataLeft >= packageLength && packageLength != 0)
                            {
                                pkg = m_socket.ReceiveUsedPacket;
                                if (m_socket.Encryted)
                                {
                                    pkg.CopyFromDecryt(m_receiveBuffer, curOffset, 0, packageLength, m_socket.PackageCrytor);
                                    m_socket.PackageCrytor.DecrytOnceComplete();
                                }
                                else
                                {
                                    pkg.CopyFrom(m_receiveBuffer, curOffset, 0, packageLength);
                                }

                                pkg.ReadHeader();

                                if (log.IsInfoEnabled) log.Info(Marshal.ToHexDump("Recieve Package：", pkg.Buffer, 0, packageLength));

                                try
                                {
                                    m_socket.ReceivePkg(pkg);
                                }
                                catch (Exception ex)
                                {
                                    log.Error("外部数据包处理出错.", ex);
                                }

                                curOffset += packageLength;
                                dataLeft = bufferSize - curOffset;
                            }
                            else
                            {
                                break;
                            }
                        }

                        if (dataLeft > 0)
                        {
                            Array.Copy(m_receiveBuffer, curOffset, m_receiveBuffer, 0, dataLeft);
                            packageBuffSize = dataLeft;
                        }

                        #endregion

                        policy = true;
                    }
                    else// if (m_socket.Sockets.Connected == false)
                    {
                        log.InfoFormat("The client of '{0}' disconnected!", m_socket.RemoteEndPoint);
                        m_socket.Disconnect();
                    }
                }
            }
            catch (Exception ex)
            {
                log.Error("数据包解析出错.", ex);
                packageBuffSize = 0;
                m_socket.Disconnect();
            }
            finally
            {
                AsyncReceiveImp();
            }
        }

        public void SendTcp(Package pkg)
        {
            if (pkg == null || m_socket == null) return;

            pkg.WriteHeader();

            pkg.postion = 0;

            if (m_socket.Sockets.Connected == false) return;

            try
            {
                lock (m_pkgQueue.SyncRoot)
                {
                    m_pkgQueue.Enqueue(pkg);

                    if (m_sendingTcp) return;

                    m_sendingTcp = true;
                }

                if (m_socket.EnableAsyncSend)
                {
                    ThreadPool.QueueUserWorkItem(new WaitCallback(SendAsyncImp), this);
                }
                else
                {
                    AsyncSendPkgComplete(this, m_sendAsyncEvent);
                }
            }
            catch (Exception ex)
            {
                log.Error("数据包发送失败.", ex);
                m_socket.Disconnect();
            }
        }

        public void ReleaseBuffer()
        {
            m_sendBuffer = null;
            m_sendBuffer = null;
        }
    }
}
