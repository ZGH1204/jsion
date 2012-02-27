using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using GameBase.Net;
using GameBase.Packets;

namespace GameServer.Packets.Handlers
{
    [PacketHandler((int)BasePacketCode.ValidateLoginResult, "登陆结果处理")]
    public class ValidateLoginResultHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            bool logined = packet.ReadBoolean();

            uint clientID = packet.ReadUnsignedInt();

            return 0;
        }
    }
}
