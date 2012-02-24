using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase;

namespace GatewayServer.Packets.OutPackets
{
    public class NoticeLoginPacket : GamePacket
    {
        public NoticeLoginPacket()
            : base(BasePacketCode.NoticeLogin, BasePacketCode.None_Code)
        { }
    }
}
