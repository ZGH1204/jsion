using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase.Managers;
using log4net;
using System.Reflection;
using GameBase.Packets;

namespace GameBase
{
    public class ServerConnector : ServerBase
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected ServerPacketHandlers m_handlers;

        public ServerConnector(string ip, int port)
            : base(ip, port)
        {
            m_handlers = new ServerPacketHandlers(this);

            OnInitialize();
        }

        public GameSocket Socket 
        {
            get { return m_socket; }
        }

        public string RemoteEndPoint
        {
            get { return m_socket.IP + ":" + m_socket.Port.ToString(); }
        }

        public virtual string ServerName
        {
            get { return "服务器"; }
        }

        public virtual void HandlePacket(GamePacket pkg)
        {
            m_handlers.HandlePacket(pkg);
        }

        public virtual void HandlePacket(int code, GamePacket pkg)
        {
            m_handlers.HandlePacket(code, pkg);
        }

        protected virtual void OnInitialize()
        {
            ServerMgr.Instance.AddConnector(this);
        }

        protected override void OnConnected(bool successed)
        {
            if (successed)
            {
                log.InfoFormat("{2}连接成功!IP:{0}, Port:{1}", Socket.IP, Socket.Port, ServerName);

                ServerMgr.Instance.SuccessConnector(this);
            }
            else
            {
                log.ErrorFormat("{2}连接失败!IP:{0}, Port:{1}", Socket.IP, Socket.Port, ServerName);

                ServerMgr.Instance.FaildConnector(this);
            }
        }

        protected override void OnDisconnect()
        {
            log.ErrorFormat("{2}连接断开!IP:{0}, Port:{1}", Socket.IP, Socket.Port, ServerName);

            ServerMgr.Instance.RemoveConnector(this);
        }

        protected override void ReceivePacket(GamePacket packet)
        {
            m_handlers.HandlePacket(packet);
        }
    }
}
