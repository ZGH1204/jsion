using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Sockets;
using log4net;
using System.Reflection;

namespace JUtils.Net
{
    public class PacketReader
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static readonly byte[] POLICY = Encoding.UTF8.GetBytes("<?xml version=\"1.0\"?><!DOCTYPE cross-domain-policy SYSTEM \"http://www.adobe.com/xml/dtds/cross-domain-policy.dtd\"><cross-domain-policy><allow-access-from domain=\"*\" to-ports=\"*\" /></cross-domain-policy>\0");

        private JSocket m_socket;

        private Packet ConfigPkg;

        private SocketAsyncEventArgs m_receiveAsyncEvent;

        private byte[] m_buffer;

        private bool m_policy = false;

        private int m_dataRemain = 0;

        private IPacketCryptor m_cryptor;

        public PacketReader(JSocket socket, byte[] buffer)
        {
            m_socket = socket;
            m_buffer = buffer;

            ConfigPkg = m_socket.UsedPacket;
            m_cryptor = m_socket.ReceiveCryptor;
            if (m_cryptor == null) m_cryptor = new NoneCryptor();

            m_receiveAsyncEvent = new SocketAsyncEventArgs();

            m_receiveAsyncEvent.Completed += new EventHandler<SocketAsyncEventArgs>(receiveAsyncEvent_Completed);
        }

        byte[] bytes = new byte[2];

        void receiveAsyncEvent_Completed(object sender, SocketAsyncEventArgs e)
        {
            try
            {
                lock (this)
                {
                    if (m_policy == false && m_buffer[0] == '<')
                    {
                        m_policy = true;
                        m_socket.Socket.Send(POLICY);
                        return;
                    }

                    if (e.BytesTransferred > 0)
                    {
                        m_policy = true;

                        #region 读取数据包

                        int bufferSize = m_dataRemain + e.BytesTransferred;

                        if (bufferSize < ConfigPkg.HeaderSize)
                        {
                            m_dataRemain = bufferSize;
                            return;
                        }

                        m_dataRemain = 0;

                        int curOffset = 0;
                        int dataLen = bufferSize;

                        int pkgLen = 0;
                        //int header = 0;

                        while (dataLen >= ConfigPkg.HeaderSize)
                        {
                            //pkgLen = 0;

                            //while ((curOffset + ConfigPkg.HeaderSize) <= bufferSize)
                            //{
                            //    bytes[0] = m_buffer[curOffset];
                            //    bytes[1] = m_buffer[curOffset + 1];

                            //    m_cryptor.Decrypt(bytes);

                            //    header = bytes[0] << 8;
                            //    header += bytes[1];

                            //    if ((short)header == ConfigPkg.Header)
                            //    {
                            //        bytes[0] = m_buffer[curOffset + ConfigPkg.PkgLenOffset];
                            //        bytes[1] = m_buffer[curOffset + ConfigPkg.PkgLenOffset + 1];

                            //        m_cryptor.Decrypt(bytes);

                            //        pkgLen = bytes[0] << 8;
                            //        pkgLen += bytes[1];
                            //        break;
                            //    }
                            //    else
                            //    {
                            //        curOffset++;
                            //    }
                            //}

                            bytes[0] = m_buffer[curOffset + ConfigPkg.PkgLenOffset];
                            bytes[1] = m_buffer[curOffset + ConfigPkg.PkgLenOffset + 1];

                            m_cryptor.Decrypt(bytes);

                            pkgLen = bytes[0] << 8;
                            pkgLen += bytes[1];

                            if (pkgLen <= 0 || pkgLen > ConfigPkg.BufferSize || pkgLen < ConfigPkg.HeaderSize)
                            {
                                log.ErrorFormat("读取的数据包长：{0}  包头长：{1}  读取时的当前游标：{2}  当前总数据流长度：{3}  当前收到数据流长度：{4}  来自：{5}", pkgLen, ConfigPkg.HeaderSize, curOffset, bufferSize, e.BytesTransferred, m_socket.RemoteEndPoint);
                                log.Error(Marshal.ToHexDump("=======================包数据==========================", m_buffer));

                                m_socket.Disconnect();
                                return;
                            }

                            dataLen = bufferSize - curOffset;

                            if (dataLen >= pkgLen)
                            {
                                Packet pkg = m_socket.UsedPacket;
                                pkg.CopyFrom(m_buffer, curOffset, 0, pkgLen);
                                m_cryptor.Decrypt(pkg.Buffer, pkgLen);
                                m_cryptor.Update();
                                pkg.ReadHeader();

                                if (log.IsInfoEnabled)
                                {
                                    log.Info(Marshal.ToHexDump("Recieve Package：", pkg.Buffer, 0, pkgLen));
                                }

                                curOffset += pkgLen;
                                dataLen = bufferSize - curOffset;

                                m_socket.ReceivePkg(pkg);
                            }
                            else
                            {
                                break;
                            }
                        }

                        if (dataLen > 0)
                        {
                            Array.Copy(m_buffer, curOffset, m_buffer, 0, dataLen);
                            m_dataRemain = dataLen;
                        }

                        #endregion
                    }
                    else
                    {
                        log.InfoFormat("The client of '{0}' disconnected!", m_socket.RemoteEndPoint);
                        m_socket.Disconnect();
                    }
                }
            }
            catch (Exception ex)
            {
                log.Error("数据包解析出错.", ex);
                m_socket.Disconnect();
            }
            finally
            {
                AsyncReceiveImp();
            }
        }

        private void AsyncReceiveImp()
        {
            if (m_socket != null && m_socket.Socket != null && m_socket.Socket.Connected)
            {
                if (m_dataRemain >= m_buffer.Length)
                {
                    log.Error("无可用缓冲区来接收数据.");
                    m_socket.Disconnect();
                }
                else
                {
                    m_receiveAsyncEvent.SetBuffer(m_buffer, m_dataRemain, m_buffer.Length - m_dataRemain);
                    if (m_socket.Socket.ReceiveAsync(m_receiveAsyncEvent) == false)
                    {
                        receiveAsyncEvent_Completed(m_socket.Socket, m_receiveAsyncEvent);
                    }
                }
            }
        }
    }
}
