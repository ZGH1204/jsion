using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using System.Net.Sockets;
using Net;
using log4net;
using System.Reflection;
using GameBase.Managers;

namespace GameBase
{
    public class ServerBase
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected GameSocket m_socket;

        #region 构造函数

        public ServerBase()
        {
            InitSocket();
        }

        public ServerBase(int port)
            : base()
        {
            Listen(port);
        }

        public ServerBase(string ip, int port)
            : base()
        {
            Connect(ip, port);
        }

        #endregion

        #region 初始化Socket

        protected void InitSocket()
        {
            m_socket = new GameSocket();

            m_socket.ConnectedSuccess += new ConnectSocketDelegate(m_socket_ConnectedSuccess);
            m_socket.ConnectedFaild += new ConnectSocketDelegate(m_socket_ConnectedFaild);

            m_socket.AcceptedSocket += new AcceptSocketDelegate(m_socket_AcceptedSocket);

            m_socket.Received += new ReceivePacketDelegate(m_socket_Received);

            m_socket.Disconnected += new DisconnectSocketDelegate(m_socket_Disconnected);
        }

        void m_socket_ConnectedSuccess(JSocket socket)
        {
            OnConnected(true);
        }

        void m_socket_ConnectedFaild(JSocket socket)
        {
            OnConnected(false);
        }




        void m_socket_AcceptedSocket(Socket socket)
        {
            ClientBase client = CreateClient(socket);

            SaveClient(client);
        }




        void m_socket_Received(Packet packet)
        {
            GamePacket gp = packet as GamePacket;

            if(gp != null) ReceivePacket(gp);
        }



        void m_socket_Disconnected()
        {
            OnDisconnect();
        }

        #endregion

        #region 可重写受保护方法

        protected virtual void OnConnected(bool successed)
        {
        }

        protected virtual void OnDisconnect()
        {
        }

        protected virtual ClientBase CreateClient(Socket socket)
        {
            return new ClientBase(socket);
        }

        protected virtual void SaveClient(ClientBase client)
        {
            ClientMgr.AddClient(client);
        }

        protected virtual void ReceivePacket(GamePacket packet)
        {
        }



        #endregion

        #region 监听端口

        public virtual bool Listen(int port)
        {
            if (port <= 0 || port > 65535)
            {
                log.Error("请监听位于0-65535区间中的端口号.");

                return false;
            }

            try
            {

                if (m_socket != null)
                {
                    m_socket.ListenLocal(port);
                    return true;
                }

                return false;
            }
            catch
            {
                return false;
            }
        }

        #endregion

        #region 连接主机

        public virtual void Connect(string ip, int port)
        {
            if (m_socket != null)
            {
                m_socket.Connect(ip, port);
            }
        }

        #endregion
    }
}
