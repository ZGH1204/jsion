using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Sockets;
using System.Collections;
using log4net;
using System.Reflection;
using System.Threading;

namespace Net
{
    public class PacketSender
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private bool m_sendingTcp;

        private Queue m_pkgQueue;

        private int m_sendingLength;

        private int m_lastPkgReadOffset;

        private JSocket m_socket;

        private byte[] m_buffer;

        private IPacketCryptor m_cryptor;

        private SocketAsyncEventArgs m_sendAsyncEvent;

        public PacketSender(JSocket socket, byte[] buffer)
        {
            m_socket = socket;
            m_buffer = buffer;
            m_pkgQueue = new Queue();

            m_cryptor = m_socket.SendCryptor;
            if (m_cryptor == null) m_cryptor = new NoneCryptor();

            m_sendAsyncEvent = new SocketAsyncEventArgs();
            m_sendAsyncEvent.UserToken = this;
            m_sendAsyncEvent.SetBuffer(m_buffer, 0, 0);
            m_sendAsyncEvent.Completed += new EventHandler<SocketAsyncEventArgs>(sendAsyncEvent_Completed);
        }

        public void SendTcp(Packet pkg)
        {
            if (pkg == null) return;

            if (!pkg.Writed)
            {
                pkg.WriteHeader();
                pkg.WriteData();
                pkg.Pack();
            }

            if (pkg.Length <= 0) return;

            if (m_socket.Socket.Connected == false)
            {
                return;
            }

            try
            {
                lock (m_pkgQueue.SyncRoot)
                {
                    m_pkgQueue.Enqueue(pkg);

                    if (m_sendingTcp)
                    {
                        return;
                    }

                    m_sendingTcp = true;
                }

                if (m_socket.EnableAsyncSend)
                {
                    ThreadPool.QueueUserWorkItem(new WaitCallback(sendAsyncImp), this);
                }
                else
                {
                    sendAsyncEvent_Completed(this, m_sendAsyncEvent);
                }
            }
            catch (Exception ex)
            {
                log.Error("数据包发送失败.", ex);
                m_socket.Disconnect();
            }
        }

        private static void sendAsyncImp(object state)
        {
            PacketSender ps = state as PacketSender;
            JSocket socket = ps.m_socket;

            try
            {
                sendAsyncEvent_Completed(socket.Socket, ps.m_sendAsyncEvent);
            }
            catch (Exception ex)
            {
                log.Error("Async send package error.", ex);
                socket.Disconnect();
            }
        }

        private static void sendAsyncEvent_Completed(object sender, SocketAsyncEventArgs e)
        {
            PacketSender ps = (PacketSender)e.UserToken;
            JSocket socket = ps.m_socket;
            Queue q = ps.m_pkgQueue;
            IPacketCryptor cryptor = ps.m_cryptor;
            int sended = e.BytesTransferred;
            byte[] data = ps.m_buffer;
            int count = ps.m_sendingLength - sended;

            if (count > 0) Array.Copy(data, sended, data, 0, count);
            else count = 0;

            e.SetBuffer(0, 0);

            int dataOffset = ps.m_lastPkgReadOffset;

            try
            {
                lock (q.SyncRoot)
                {
                    while (q.Count > 0)
                    {
                        Packet pkg = (Packet)q.Peek();

                        int len = 0;

                        if (dataOffset == 0)
                        {
                            cryptor.Encrypt(pkg.Buffer, pkg.Length);
                        }

                        len = pkg.CopyTo(data, count, dataOffset);

                        dataOffset += len;
                        count += len;

                        if (pkg.Length <= dataOffset)
                        {
                            q.Dequeue();
                            dataOffset = 0;
                            //cryptor.Decrypt(pkg.Buffer, pkg.Length);
                            cryptor.Update();
                        }

                        if (data.Length == count)
                        {
                            break;
                        }
                    }

                    ps.m_lastPkgReadOffset = dataOffset;

                    if (count <= 0)
                    {
                        ps.m_sendingTcp = false;
                        return;
                    }
                }

                ps.m_sendingLength = count;

                e.SetBuffer(0, count);

                if (socket.Socket.SendAsync(e) == false)
                {
                    sendAsyncEvent_Completed(sender, e);
                }
            }
            catch (Exception ex)
            {
                log.Error("Async sending package error.", ex);
                socket.Disconnect();
            }
        }
    }
}
