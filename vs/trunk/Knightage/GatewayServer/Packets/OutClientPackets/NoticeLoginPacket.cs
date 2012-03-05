using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase;

namespace GatewayServer.Packets.OutClientPackets
{
    public class NoticeLoginPacket : ClientPacket
    {
        public NoticeLoginPacket()
            : base(BasePacketCode.NoticeLogin)
        {

        }
    }
}
