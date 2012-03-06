using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;
using CenterServer.Packets.OutPackets;

namespace CenterServer.Packets.Handlers
{
    [PacketHandler((int)BasePacketCode.LoginAfterKit, "旧玩家客户端被踢下线后 中心服务器处理登陆")]
    public class LoginAfterKitHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            CenterPlayer player = CenterGlobal.PlayerMgr[packet.PlayerID];

            if (player != null)
            {
                ValidateLoginPacket pkg = new ValidateLoginPacket();
                pkg.PlayerID = player.PlayerID;
                pkg.ClientID = player.ClientID;
                player.SendTcp(pkg);
            }

            return 0;
        }
    }
}
