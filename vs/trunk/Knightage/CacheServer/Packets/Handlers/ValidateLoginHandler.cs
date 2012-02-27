using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;

namespace CacheServer.Packets.Handlers
{
    [PacketHandler((int)BasePacketCode.ValidateLogin, "验证登陆")]
    public class ValidateLoginHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            uint clientID = packet.ReadUnsignedInt();

            string account = packet.ReadUTF();

            //TODO: 从数据库验证帐号

            return 0;
        }
    }
}
