using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Sockets;
using log4net;
using System.Reflection;
using System.Net;

namespace Net
{
    public class SocketAccepter
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private JSocket m_socket;

        private SocketAsyncEventArgs m_acceptAsyncEvent;

        public SocketAccepter(JSocket socket)
        {
            m_socket = socket;
        }

        public void ListenLocal(int port)
        {
            m_acceptAsyncEvent = new SocketAsyncEventArgs();
            m_acceptAsyncEvent.Completed += new EventHandler<SocketAsyncEventArgs>(acceptAsyncEvent_Completed);

            try
            {
                IPEndPoint ep = new IPEndPoint(IPAddress.Any, port);

                m_socket.Socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.IP);

                m_socket.Socket.Bind(ep);

                m_socket.Socket.Listen(100);

                log.InfoFormat("建立本地监听成功! Port:{0}", ep.Port.ToString());
            }
            catch (Exception ex)
            {
                log.Error("本地监听建立失败.", ex);
                throw ex;
            }

            acceptAsync(m_socket.Socket, m_acceptAsyncEvent);
        }

        void acceptAsync(Socket socket, SocketAsyncEventArgs e)
        {
            e.AcceptSocket = null;

            if (socket.AcceptAsync(e) == false)
            {
                acceptAsyncEvent_Completed(socket, e);
            }
        }

        void acceptAsyncEvent_Completed(object sender, SocketAsyncEventArgs e)
        {
            Socket socket = null;

            try
            {
                socket = e.AcceptSocket;
            }
            catch (Exception ex)
            {
                if (socket != null)
                {
                    try
                    {
                        socket.Close();
                    }
                    catch
                    { }
                }

                log.Error("获取客户端Socket连接错误.", ex);
                m_socket.Disconnect();
                return;
            }

            m_socket.ListenAcceptSocket(socket);

            acceptAsync(m_socket.Socket, m_acceptAsyncEvent);
        }
    }
}
