using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase;

namespace GatewayServer.Packets.OutPackets.Servers
{
    public class UpdateServerNormalPacket : CenterPacket
    {
        public UpdateServerNormalPacket()
            : base(BasePacketCode.UpdateServerNormal)
        { }

        public uint GatewayID { get; set; }

        public override void WriteData()
        {
            WriteUnsignedInt(GatewayID);
        }
    }
}
