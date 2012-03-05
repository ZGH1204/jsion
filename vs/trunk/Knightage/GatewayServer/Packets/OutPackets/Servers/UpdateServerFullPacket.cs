using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase;

namespace GatewayServer.Packets.OutPackets.Servers
{
    public class UpdateServerFullPacket : CenterPacket
    {
        public UpdateServerFullPacket()
            : base(BasePacketCode.UpdateServerFull)
        { }

        public uint GatewayID { get; set; }

        public uint ClientID { get; set; }

        public override void WriteData()
        {
            WriteUnsignedInt(GatewayID);

            WriteUnsignedInt(ClientID);
        }
    }
}
