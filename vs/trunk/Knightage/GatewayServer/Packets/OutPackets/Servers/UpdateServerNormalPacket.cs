using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase;

namespace GatewayServer.Packets.OutPackets.Servers
{
    public class UpdateServerNormalPacket : GamePacket
    {
        public UpdateServerNormalPacket()
            : base()
        {
            Code = (int)BasePacketCode.UpdateServerNormal;
            Code2 = (int)BasePacketCode.Center_Code;
        }

        public uint GatewayID { get; set; }

        public override void WriteData()
        {
            WriteUnsignedInt(GatewayID);
        }
    }
}
