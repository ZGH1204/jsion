using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase;

namespace GatewayServer.Packets.OutServerPackets
{
    public class UpdateServerNormalPacket : CenterPacket
    {
        public UpdateServerNormalPacket()
            : base(BasePacketCode.UpdateServerNormal)
        {

        }

        public override void WriteData()
        {
            WriteUnsignedInt(GatewayGlobal.GatewayID);
        }
    }
}
