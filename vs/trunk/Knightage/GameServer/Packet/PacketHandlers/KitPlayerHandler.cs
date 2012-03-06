using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;
using GameServer.Packet.OutServerPackets;
using GameServer.Packet.OutPackets;

namespace GameServer.Packet.PacketHandlers
{
    [PacketHandler((int)BasePacketCode.KitPlayer, "玩家被踢下线 保存到数据库后通知中心服务器可以登陆")]
    public class KitPlayerHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            GamePlayer player = GameGlobal.PlayerMgr[packet.PlayerID];

            if (player != null)
            {
                player.SaveToDatabase();
                player.Logout();

                KitPlayerPacket p = new KitPlayerPacket(packet.PlayerID);
                player.SendTcp(p);
            }

            GameGlobal.PlayerMgr.Remove(packet.PlayerID);

            LoginAfterKitPacket pkg = new LoginAfterKitPacket();

            pkg.PlayerID = packet.PlayerID;

            GameGlobal.CenterServer.SendTCP(pkg);

            return 0;
        }
    }
}
