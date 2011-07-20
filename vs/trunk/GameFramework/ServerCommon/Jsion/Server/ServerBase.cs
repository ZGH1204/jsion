using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using log4net;
using System.Reflection;
using System.Net.Sockets;
using ServerCommon.Jsion.Client;
using Jsion.NetWork.Packet;
using Jsion.NetWork.Sockets;

namespace ServerCommon.Jsion.Server
{
    public class ServerBase
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected SSocket m_socket;

        #region 事件

        public delegate void SaveClientDelegate(ClientBase client);

        public event SaveClientDelegate SaveClientEvent;

        #endregion

        #region 构造函数

        public ServerBase()
        {
            Init();
            InitSocket();
        }

        public ServerBase(int port)
            :base()
        {
            ListenLocal(port);
        }

        #endregion

        #region 初始化ByteSocket对象,并添加Accept和Receive处理函数 可重写CreateClient和SaveClient(必须),以及ReceivePackage方法

        protected void InitSocket()
        {
            m_socket = new SSocket();
            m_socket.ConnectSuccessHandler += new ByteSocket.ConnectSocketDelegate(m_socket_ConnectSuccessHandler);
            m_socket.ConnectFailedHandler += new ByteSocket.ConnectSocketDelegate(m_socket_ConnectFailedHandler);
            m_socket.DisconnectHandler += new ByteSocket.DisconnectSocketDelegate(m_socket_DisconnectHandler);
            m_socket.AcceptSocketHandler += new SSocket.AcceptSocketDelegate(m_socket_AcceptSocketHandler);
            m_socket.ReceivePkgHandler += new SSocket.ReceivePkgDelegate(ReceivePackage);
        }

        private void m_socket_DisconnectHandler()
        {
            OnDisconnect();
        }

        private void m_socket_ConnectSuccessHandler(ByteSocket bSock)
        {
            OnConnected(true);
        }

        private void m_socket_ConnectFailedHandler(ByteSocket bSock)
        {
            OnConnected(false);
        }

        private void m_socket_AcceptSocketHandler(Socket sock)
        {
            ClientBase client = CreateClient(sock);
            SaveClient(client);
            if (SaveClientEvent != null) SaveClientEvent(client);
        }

        #endregion

        #region 可重写保护方法

        protected virtual void Init()
        {

        }

        protected virtual void OnConnected(bool successed)
        {
        }

        protected virtual void OnDisconnect()
        {
        }

        protected virtual ClientBase CreateClient(Socket sock)
        {
            return new ClientBase(sock);
        }

        protected virtual void SaveClient(ClientBase client)
        {
        }

        protected virtual void ReceivePackage(Package pkg)
        {
            //throw new NotImplementedException();
        }

        #endregion

        #region 连接指定主机

        public virtual void Connect(string ip, int port)
        {
            if (m_socket != null)
            {
                m_socket.Connect(ip, port);
            }
        }

        #endregion

        #region 监听指定端口号

        public virtual bool ListenLocal(int port)
        {
            if (port <= 0 || port > 65535) log.Error("请监听位于0-65535区间中的端口号.");
            if (m_socket != null) return m_socket.ListenLocal(port);
            return false;
        }

        #endregion
    }
}
