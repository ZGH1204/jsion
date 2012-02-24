using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;

namespace GatewayServer.Packets.Handlers.Servers
{
    [PacketHandler((int)BasePacketCode.ServerBusies, "转发通知客户端服务器繁忙")]
    public class ServerBusiesHandler : IServerPacketHandler
    {
        public int HandlePacket(ServerConnector connector, GamePacket packet)
        {
            uint clientID = packet.ReadUnsignedInt();

            ClientBase client = GatewayGlobal.PlayerClientMgr[clientID];

            if (client != null)
            {
                client.SendTcp(packet);
            }

            return 0;
        }
    }
}
