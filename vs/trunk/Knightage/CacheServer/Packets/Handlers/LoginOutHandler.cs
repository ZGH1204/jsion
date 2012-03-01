using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;

namespace CacheServer.Packets.Handlers
{
    [PacketHandler((int)BasePacketCode.LoginOut, "玩家登出")]
    public class LoginOutHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            Player player = CacheGlobal.CachePlayerMgr.Remove(packet.PlayerID);

            if (player != null)
            {
                CacheGlobal.LoginPlayerMgr.RemovePlayer(player);
            }

            return 0;
        }
    }
}
