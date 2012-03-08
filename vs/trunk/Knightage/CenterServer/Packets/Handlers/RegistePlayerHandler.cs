using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase.Net;
using GameBase;
using Bussiness;
using CenterServer.Packets.OutPackets;

namespace CenterServer.Packets.Handlers
{
    [PacketHandler((int)BasePacketCode.ValidateRegiste, "角色注册")]
    public class RegistePlayerHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            uint clientID = packet.ReadUnsignedInt();
            string account = packet.ReadUTF();
            string nickName = packet.ReadUTF();

            uint playerID = 0;

            using (PlayerBussiness pb = new PlayerBussiness())
            {
                playerID = pb.Registe(account, nickName);
            }

            if (playerID != 0)
            {
                ValidateLoginHandler.SendLoginPacket(client, clientID, account, playerID);
            }
            else
            {
                //TODO: 发送创建角色失败给客户端

                RegisteResultPacket pkg = new RegisteResultPacket();

                pkg.ClientID = clientID;

                client.SendTcp(pkg);
            }

            return 0;
        }
    }
}
