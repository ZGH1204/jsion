using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;
using GameBase.Datas;
using System.Threading;
using JUtils;
using CenterServer.Packets.OutPackets;

namespace CenterServer.Packets.Handlers
{
    [PacketHandler((int)BasePacketCode.Login, "玩家登陆")]
    public class PlayerLoginHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            string account = packet.ReadUTF();

            if (account.IsNullOrEmpty())
            {
                //TODO: 发送登陆失败数据包
                client.SendTcp(new PlayerLoginFailedPacket());
                //client.Disconnect();
                return 0;
            }

            Interlocked.Increment(ref CenterGlobal.PlayerCount);

            PlayerInfo info = new PlayerInfo();

            info.PlayerID = (uint)CenterGlobal.PlayerCount;
            info.Account = account;
            info.NickName = RandomChinese.GetRandomChinese(3);

            CenterPlayer player = new CenterPlayer(info, client);

            CenterGlobal.LoginPlayerMgr.AddPlayer(player);

            return 0;
        }
    }
}
