using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase.Net;
using GameBase;

namespace CacheServer.Packets
{
    [PacketHandler((int)BasePacketCode.Cache_Code, "处理缓存服务器的数据包")]
    public class ProgressCachePacketHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            client.HandlePacket(packet.Code, packet);

            return 0;
        }
    }
}
