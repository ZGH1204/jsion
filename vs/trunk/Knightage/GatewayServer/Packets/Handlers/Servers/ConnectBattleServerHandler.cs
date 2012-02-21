using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;

namespace GatewayServer.Packets.Handlers.Servers
{
    [PacketHandler((int)BasePacketCode.ConnectBattleServer, "连接战斗服务器")]
    public class ConnectBattleServerHandler : IServerPacketHandler
    {
        public int HandlePacket(ServerConnector connector, GamePacket packet)
        {
            int id = packet.ReadInt();

            if (GatewayGlobal.ContainsBattleServer(id))
            {
                return 0;
            }

            string ip = packet.ReadUTF();

            int port = packet.ReadInt();

            new BattleServerConnector(id, ip, port);

            return 0;
        }
    }
}
