using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;

namespace GameServer.Packet.OutPackets
{
    public class KitPlayerPacket : ClientPacket
    {
        public KitPlayerPacket(uint playerID)
            : base(GameBase.BasePacketCode.KitPlayer)
        {
            PlayerID = playerID;
        }
    }
}
