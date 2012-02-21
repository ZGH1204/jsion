using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using System.Reflection;
using log4net;

namespace GatewayServer
{
    public class GameLogicServerConnector : ServerConnector
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public int ID { get; protected set; }

        public GameLogicServerConnector(int id, string ip, int port)
            : base(ip, port)
        {
            ID = id;

            GatewayGlobal.ConnectingMgr.Add(ID, this);
        }

        public override string ServerName
        {
            get
            {
                return "逻辑服务器";
            }
        }

        protected override void OnInitialize()
        {
        }

        protected override void OnConnected(bool successed)
        {
            if (successed)
            {
                log.InfoFormat("{2}连接成功!IP:{0}, Port:{1}", Socket.IP, Socket.Port, ServerName);

                GatewayGlobal.GameLogicServerMgr.Add(ID, this);
            }
            else
            {
                log.ErrorFormat("{2}连接失败!IP:{0}, Port:{1}", Socket.IP, Socket.Port, ServerName);
            }

            GatewayGlobal.ConnectingMgr.Remove(ID);
        }

        protected override void OnDisconnect()
        {
            GatewayGlobal.GameLogicServerMgr.Remove(ID);
        }
    }
}
