using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase;

namespace CenterServer.Packets.OutPackets
{
    public class ServerBusiesPacket : GatewayPacket
    {
        public ServerBusiesPacket()
            : base(BasePacketCode.ServerBusies)
        { }

        public uint ClientID { get; set; }

        public override void WriteData()
        {
            WriteUnsignedInt(ClientID);
        }
    }
}
