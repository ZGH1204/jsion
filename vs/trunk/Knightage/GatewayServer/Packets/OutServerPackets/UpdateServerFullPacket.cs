using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase;

namespace GatewayServer.Packets.OutServerPackets
{
    public class UpdateServerFullPacket : CenterPacket
    {
        public UpdateServerFullPacket()
            : base(BasePacketCode.UpdateServerFull)
        {
        }

        public uint ClientID { get; set; }

        public override void WriteData()
        {
            WriteUnsignedInt(GatewayGlobal.GatewayID);
            WriteUnsignedInt(ClientID);
        }
    }
}
