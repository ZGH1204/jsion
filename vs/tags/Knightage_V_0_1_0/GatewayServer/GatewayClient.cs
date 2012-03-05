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

        public GatewayClient()
            : base()
        { }

        protected override void OnDisconnected()
        {
            base.OnDisconnected();

            GatewayGlobal.PlayerClientMgr.Remove(ClientID);
            GatewayGlobal.PlayerLoginMgr.Remove(PlayerID);
        }

        public new GatewayPlayer Player { get; set; }
    }
}
