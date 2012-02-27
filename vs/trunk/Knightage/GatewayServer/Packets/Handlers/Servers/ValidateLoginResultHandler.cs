using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;
using GatewayServer.Packets.OutPackets;

namespace GatewayServer.Packets.Handlers.Servers
{
    [PacketHandler((int)BasePacketCode.ValidateLoginResult, "缓存服务器登陆验证结果")]
    public class ValidateLoginResultHandler : IServerPacketHandler
    {
        public int HandlePacket(ServerConnector connector, GamePacket packet)
        {
            bool logined = packet.ReadBoolean();

            uint clientID = packet.ReadUnsignedInt();

            if (logined)
            {
                //TODO: 记录PlayerID与ClientID的对应关系
                //TODO: 转发结果到逻辑服务器
            }
            else
            {
                LoginFailedPacket pkg = new LoginFailedPacket();

                GatewayGlobal.PlayerClientMgr[clientID].SendTcp(pkg);
            }

            return 0;
        }
    }
}
