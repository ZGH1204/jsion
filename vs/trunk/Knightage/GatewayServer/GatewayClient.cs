using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;

namespace GatewayServer
{
    public class GatewayClient : ClientBase
    {
        public uint ClientID { get; set; }
        public uint PlayerID { get; set; }
        public ServerConnector LogicServer { get; set; }

        public GatewayClient()
            : base()
        { }

        protected override void OnDisconnected()
        {
            base.OnDisconnected();

            LogicServer = null;
            GatewayGlobal.PlayerClientMgr.Remove(ClientID);
            GatewayGlobal.PlayerLoginMgr.Remove(PlayerID);
        }
    }
}
