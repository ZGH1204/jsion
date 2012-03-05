using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;
using GameBase.Managers;

namespace GatewayServer.Packets.ServerHandlers
{
    [PacketHandler((int)BasePacketCode.ReConnectGateway, "重新连接其他网关")]
    public class ReConnectGatewayHandler : IServerPacketHandler
    {
        public int HandlePacket(ServerConnector connector, GamePacket packet)
        {
            uint clientID = packet.ReadUnsignedInt();

            GatewayClient client = GatewayGlobal.Clients[clientID];

            if (client != null)
            {
                client.SendTcp(packet);
            }

            return 0;
        }
    }
}
