using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using GatewayServer.Packets.OutServerPackets;

namespace GatewayServer
{
    public class GatewayClient : ClientBase
    {
        public uint ClientID { get; protected set; }
        public uint PlayerID { get; set; }
        public string Account { get; set; }

        public new GatewayPlayer Player { get; set; }

        public LogicServerConnector LogicServer { get; set; }

        public GatewayClient()
            : base()
        { }

        public void SetClientID(uint id)
        {
            ClientID = id;

            GatewayGlobal.Clients.Add(ClientID, this);
        }

        protected override void OnDisconnected()
        {
            base.OnDisconnected();

            GatewayGlobal.Clients.Remove(ClientID);

            if (PlayerID != 0)
            {
                ClientDisconnectPacket pkg = new ClientDisconnectPacket(PlayerID);

                pkg.ClientID = ClientID;

                LogicServer.SendTCP(pkg);

                pkg = new ClientDisconnectPacket(PlayerID);

                pkg.ClientID = ClientID;

                GatewayGlobal.Send2Center(pkg, this);
            }

            if (Player != null)
            {
                Player.OnDisconnect();
            }
        }
    }
}
