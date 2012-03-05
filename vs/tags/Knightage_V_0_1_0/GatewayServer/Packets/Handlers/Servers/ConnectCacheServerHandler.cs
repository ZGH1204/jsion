using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;

namespace GatewayServer.Packets.Handlers.Servers
{
    [PacketHandler((int)BasePacketCode.ConnectCacheServer, "连接缓存服务器")]
    public class ConnectCacheServerHandler : IServerPacketHandler
    {
        public int HandlePacket(ServerConnector connector, GamePacket packet)
        {
            string ip = packet.ReadUTF();

            int port = packet.ReadInt();

            if (GatewayGlobal.CacheServer == null || GatewayGlobal.CacheServer.Socket.Connected == false)
            {
                GatewayGlobal.CacheServer = new CacheServerConnector(ip, port);
            }

            return 0;
        }
    }
}
