using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase;

namespace GatewayServer.Packets.OutServerPackets
{
    public class ChangeGatewayPacket : CenterPacket
    {
        public ChangeGatewayPacket()
            : base(BasePacketCode.ChangeGateway)
        {

        }

        public int ClientID { get; set; }

        public override void WriteData()
        {
            WriteInt(GatewayGlobal.GatewayID);
            WriteInt(ClientID);
        }
    }
}
