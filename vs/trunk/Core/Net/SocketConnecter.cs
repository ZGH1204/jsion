using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using log4net;
using System.Reflection;
using System.Net.Sockets;
using System.Net;
using System.Text.RegularExpressions;

namespace Net
{
    public class SocketConnecter
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private JSocket m_socket;

        public SocketConnecter(JSocket socket)
        {
            m_socket = socket;
        }

        bool IsIP(string scope)
        {
            return Regex.IsMatch(scope, @"^((2[0-4]\d|25[0-5]|[01]?\d\d?)\.){3}(2[0-4]\d|25[0-5]|[01]?\d\d?)$");
        }

        public void Connect(string ip, int port)
        {
            if (!IsIP(ip))
            {
                log.ErrorFormat("The target host address is error.IP:{0}, Port:{1}", ip, port);
                return;
            }

            try
            {
                m_socket.IP = ip;
                m_socket.Port = port;

                m_socket.HadTryTimes = 0;

                TryConnect(m_socket.IP, m_socket.Port);
            }
            catch (Exception ex)
            {
                log.Error("连接失败.", ex);
            }
        }

        void TryConnect(string ip, int port)
        {
            m_socket.Socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            SocketAsyncEventArgs connectAsyncEvent = new SocketAsyncEventArgs();
            IPEndPoint ep = new IPEndPoint(IPAddress.Parse(ip), port);
            connectAsyncEvent.RemoteEndPoint = ep;
            connectAsyncEvent.Completed += new EventHandler<SocketAsyncEventArgs>(connectAsyncEvent_Completed);

            if (!m_socket.Socket.ConnectAsync(connectAsyncEvent))
            {
                connectAsyncEvent_Completed(m_socket.Socket, connectAsyncEvent);
            }
        }

        void connectAsyncEvent_Completed(object sender, SocketAsyncEventArgs e)
        {
            if (e.ConnectSocket != null)
            {
                m_socket.ConnectedSuccessed();
            }
            else
            {
                if (m_socket.CanTryTimes >= 0)
                {
                    m_socket.HadTryTimes++;
                }

                if (m_socket.HadTryTimes > m_socket.CanTryTimes)
                {
                    log.ErrorFormat("Connect ip: {0}, port: {1} failed.", m_socket.IP, m_socket.Port);
                    m_socket.ConnectedFailded();
                }
                else
                {
                    log.WarnFormat("Try connect ip: {0}, port:{1} again. Current try times is {2}", m_socket.IP, m_socket.Port, m_socket.HadTryTimes);
                    TryConnect(m_socket.IP, m_socket.Port);
                }
            }
        }
    }
}
