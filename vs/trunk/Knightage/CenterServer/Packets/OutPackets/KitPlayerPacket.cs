using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;

namespace CenterServer.Packets.OutPackets
{
    public class KitPlayerPacket : LogicPacket
    {
        public KitPlayerPacket()
            : base(GameBase.BasePacketCode.KitPlayer)
        {

        }
    }
}
