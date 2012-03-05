using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using System.Reflection;
using log4net;
using GameBase.Net;

namespace GatewayServer
{
    public class LogicServerConnector : ServerConnector
    {
        //private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public static readonly int MaxClients = 5000;

        public uint ID { get; protected set; }

        public int ClientCount { get; protected set; }

        public readonly object SyncRoot = new object();

        public LogicServerConnector(uint id)
            : base()
        {
            ID = id;

            GatewayGlobal.LogicConnectingMgr.Add(ID, this);
        }

        public override string ServerName
        {
            get
            {
                return "逻辑服务器";
            }
        }

        protected override void OnConnected(bool successed)
        {
            base.OnConnected(successed);

            if (successed)
            {
                GatewayGlobal.LogicConnectingMgr.Remove(ID);
                GatewayGlobal.LogicServerMgr.Add(ID, this);
            }
            else
            {
                GatewayGlobal.LogicConnectingMgr.Remove(ID);
            }
        }
    }
}
