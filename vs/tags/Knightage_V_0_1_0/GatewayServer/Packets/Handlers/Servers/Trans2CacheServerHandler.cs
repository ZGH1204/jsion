using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;

namespace GatewayServer.Packets.Handlers.Servers
{
    [PacketHandler((int)BasePacketCode.Cache_Code, "转发数据包到缓存服务器上")]
    public class Trans2CacheServerHandler : IServerPacketHandler
    {
        public int HandlePacket(ServerConnector connector, GamePacket packet)
        {
            if (GatewayGlobal.CacheServer != null && GatewayGlobal.CacheServer.Socket.Connected)
            {
                GatewayGlobal.CacheServer.SendTCP(packet);
            }
            else
            {
                //TODO: 通知客户端没有可用缓存服务器
            }

            return 0;
        }
    }
}
