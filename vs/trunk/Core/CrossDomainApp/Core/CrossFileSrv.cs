using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Sockets;
using System.Reflection;
using System.Net;

namespace CrossDomainApp.Core
{
    public class CrossFileSrv
    {
        public Socket Socket { get; protected set; }

        private SocketAsyncEventArgs m_acceptAsyncEvent;

        public event AcceptSocketDelegate AcceptSocket;

        public CrossFileSrv()
        {
            m_acceptAsyncEvent = new SocketAsyncEventArgs();
            m_acceptAsyncEvent.Completed += new EventHandler<SocketAsyncEventArgs>(m_acceptAsyncEvent_Completed);
        }

        void m_acceptAsyncEvent_Completed(object sender, SocketAsyncEventArgs e)
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

                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine("获取客户端Socket连接错误.");
                Console.WriteLine(ex);
                Console.ResetColor();

                return;
            }

            if (AcceptSocket != null) AcceptSocket(socket);

            acceptAsync(Socket, m_acceptAsyncEvent);
        }

        public void Listen(int port = 843)
        {
            try
            {
                IPEndPoint ep = new IPEndPoint(IPAddress.Any, port);

                Socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.IP);

                Socket.Bind(ep);

                Socket.Listen(100);

                Console.WriteLine("建立本地监听成功! Port:{0}", ep.Port.ToString());

                acceptAsync(Socket, m_acceptAsyncEvent);
            }
            catch (Exception ex)
            {
                Console.WriteLine("本地监听建立失败.");
                Console.WriteLine(ex);
            }
        }

        void acceptAsync(Socket socket, SocketAsyncEventArgs e)
        {
            e.AcceptSocket = null;

            if (socket.AcceptAsync(e) == false)
            {
                m_acceptAsyncEvent_Completed(socket, e);
            }
        }

        public virtual void Disconnect()
        {
            if (Socket != null)
            {
                try { Socket.Shutdown(SocketShutdown.Both); }
                catch { }

                try { Socket.Close(); }
                catch { }

                Socket = null;
            }
        }
    }
}
