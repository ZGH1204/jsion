using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase;

namespace GatewayServer.Packets.OutPackets.Servers
{
    public class ConnectOtherGatewayPacket : GamePacket
    {
        public ConnectOtherGatewayPacket()
            : base()
        {
            Code = (int)BasePacketCode.ConnectOtherGateway;
            Code2 = (int)BasePacketCode.Center_Code;
        }

        public int GatewayID { get; set; }
        public int ClientID { get; set; }

        public override void WriteData()
        {
            WriteInt(GatewayID);
            WriteInt(ClientID);
        }
    }
}
