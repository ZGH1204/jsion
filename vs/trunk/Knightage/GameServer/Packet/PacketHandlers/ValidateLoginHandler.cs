using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;
using GameBase.Datas;

namespace GameServer.Packet.PacketHandlers
{
    [PacketHandler((int)BasePacketCode.ValidateLogin, "中心服务器验证成功 逻辑服务器获取玩家信息")]
    public class ValidateLoginHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            int clientID = packet.ReadInt();

            LoginInfo info = new LoginInfo();

            info.PlayerID = packet.PlayerID;

            GamePlayer player = new GamePlayer(info, client as GameClient);

            player.ClientID = clientID;

            player.Logined();

            GameGlobal.PlayerMgr.Add(player.PlayerID, player);

            GameGlobal.CheckMaxClientCount();

            return 0;
        }
    }
}
