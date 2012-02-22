using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;

namespace GatewayServer.Packets.Handlers.Servers
{
    [PacketHandler((int)BasePacketCode.Login, "玩家登陆结果")]
    public class PlayerLoginHandler : IServerPacketHandler
    {
        public int HandlePacket(ServerConnector connector, GamePacket packet)
        {
            GamePacket pkg = packet.Clone();

            bool result = packet.ReadBoolean();

            if (result)
            {

            }
            else
            {

            }

            return 0;
        }
    }
}
