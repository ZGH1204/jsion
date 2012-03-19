using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;

namespace GatewayServer.Packets.ServerHandlers
{
    [PacketHandler((int)BasePacketCode.ServerBusies, "网关已满")]
    public class ServerBusiesHandler : IServerPacketHandler
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
