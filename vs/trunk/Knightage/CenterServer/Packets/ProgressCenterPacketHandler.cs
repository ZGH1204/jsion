using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase.Net;
using GameBase;

namespace CenterServer.Packets
{
    [PacketHandler((int)BasePacketCode.Center_Code, "处理中心服务器的数据包")]
    public class ProgressCenterPacketHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            client.HandlePacket(packet.Code, packet);

            return 0;
        }
    }
}
