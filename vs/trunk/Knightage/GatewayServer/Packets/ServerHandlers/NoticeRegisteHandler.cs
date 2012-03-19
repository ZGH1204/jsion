using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;

namespace GatewayServer.Packets.ServerHandlers
{
    [PacketHandler((int)BasePacketCode.NoticeRegiste, "通知客户端玩家进行注册")]
    public class NoticeRegisteHandler : IServerPacketHandler
    {
        public int HandlePacket(ServerConnector connector, GamePacket packet)
        {
            int clientID = packet.ReadInt();

            GatewayClient client = GatewayGlobal.Clients[clientID];

            if (client != null)
            {
                client.SendTcp(packet);
            }

            return 0;
        }
    }
}
