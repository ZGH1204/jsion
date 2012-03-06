using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase.Packets;

namespace GameServer.Packet.OutServerPackets
{
    public class LoginAfterKitPacket : CenterPacket
    {
        public LoginAfterKitPacket()
            : base(GameBase.BasePacketCode.LoginAfterKit)
        {

        }
    }
}
