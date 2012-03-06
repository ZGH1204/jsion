using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using GameBase.Datas;

namespace GatewayServer
{
    public class GatewayPlayer : Player
    {
        public new GatewayClient Client { get; protected set; }

        public GatewayPlayer(PlayerInfo info, GatewayClient client)
            : base(info, client)
        {
            Client = client;

            Client.PlayerID = PlayerID;
        }

        public override void OnDisconnect()
        {
            base.OnDisconnect();

            lock (GatewayGlobal.Players.SyncRoot)
            {
                if (GatewayGlobal.Players[PlayerID] == this)
                {
                    GatewayGlobal.Players.Remove(PlayerID);
                }
            }
        }
    }
}
