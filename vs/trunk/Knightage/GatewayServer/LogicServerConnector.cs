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

        public int ID { get; protected set; }

        public int ClientCount { get; protected set; }

        public readonly object SyncRoot = new object();

        private bool m_fulled;

        public LogicServerConnector(int id)
            : base()
        {
            ID = id;

            GatewayGlobal.LogicConnectingMgr.Add(ID, this);
        }

        public bool Fulled
        {
            get
            {
                lock (SyncRoot)
                {
                    return m_fulled;
                }
            }
            set
            {
                lock (SyncRoot)
                {
                    m_fulled = value;
                }
            }
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

        protected override void OnDisconnect()
        {
            base.OnDisconnect();

            if (GatewayGlobal.LogicServerMgr[ID] == this)
            {
                GatewayGlobal.LogicServerMgr.Remove(ID);
            }

            GatewayPlayer[] players = GatewayGlobal.Players.Select(p => p.Client.LogicServer == this);

            foreach (GatewayPlayer player in players)
            {
                GatewayGlobal.Players.Remove(player.PlayerID);
                player.Client.Disconnect();
            }
        }
    }
}
