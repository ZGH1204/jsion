using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;
using Bussiness;
using CenterServer.Packets.OutPackets;
using GameBase.Datas;

namespace CenterServer.Packets.Handlers
{
    [PacketHandler((int)BasePacketCode.ValidateLogin, "验证登陆")]
    public class ValidateLoginHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            uint clientID = packet.ReadUnsignedInt();
            string account = packet.ReadUTF();

            uint playerID = 0;

            using (PlayerBussiness pb = new PlayerBussiness())
            {
                playerID = pb.GetID(account);
            }


            if (playerID != 0)
            {
                PlayerInfo info = new PlayerInfo();

                info.PlayerID = playerID;
                info.Account = account;

                CenterPlayer player = new CenterPlayer(info, client);
                player.ClientID = clientID;
                player.Logined();

                if (CenterGlobal.PlayerMgr.Contains(playerID))
                {
                    //TODO: 发送踢下线通知 并在保存到数据库后通知中心服务器进行登陆后续操作

                    CenterPlayer player2 = CenterGlobal.PlayerMgr[playerID];

                    player2.Logout();

                    CenterGlobal.PlayerMgr.Remove(playerID);

                    CenterGlobal.PlayerMgr.Add(playerID, player);

                    KitPlayerPacket p = new KitPlayerPacket();
                    p.PlayerID = playerID;
                    player2.SendTcp(p);
                }
                else
                {
                    CenterGlobal.PlayerMgr.Add(playerID, player);

                    ValidateLoginPacket pkg = new ValidateLoginPacket();
                    pkg.PlayerID = playerID;
                    pkg.ClientID = clientID;
                    player.SendTcp(pkg);
                }
            }
            else
            {
                //TODO: 无此玩家 发送注册包到客户端进行注册

                RegistePlayerPacket pkg = new RegistePlayerPacket();

                pkg.ClientID = clientID;

                client.SendTcp(pkg);
            }

            return 0;
        }
    }
}
