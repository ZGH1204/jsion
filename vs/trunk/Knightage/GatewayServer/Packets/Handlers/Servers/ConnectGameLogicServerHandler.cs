using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;

namespace GatewayServer.Packets.Handlers.Servers
{
    [PacketHandler((int)BasePacketCode.ConnectLogicServer, "连接逻辑服务器")]
    public class ConnectGameLogicServerHandler : IServerPacketHandler
    {
        public int HandlePacket(ServerConnector connector, GamePacket packet)
        {
            uint id = packet.ReadUnsignedInt();

            if (GatewayGlobal.ContainsGameLogicServer(id))
            {
                return 0;
            }

            string ip = packet.ReadUTF();

            int port = packet.ReadInt();

            new GameLogicServerConnector(id, ip, port);

            return 0;
        }
    }
}
