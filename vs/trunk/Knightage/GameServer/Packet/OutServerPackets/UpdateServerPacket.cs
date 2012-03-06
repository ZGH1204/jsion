using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase;

namespace GameServer.Packet.OutServerPackets
{
    public class UpdateServerFullPacket : GatewayPacket
    {
        public UpdateServerFullPacket()
            : base(BasePacketCode.UpdateServerFull)
        {

        }
    }

    public class UpdateServerNormalPacket : GatewayPacket
    {
        public UpdateServerNormalPacket()
            : base(BasePacketCode.UpdateServerNormal)
        {

        }
    }
}
