using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase.Net;
using GameBase;

namespace GameServer.Packets.ServerPacketHandlers
{
    [PacketHandler((int)BasePacketCode.Logic_Code, "处理逻辑服务器的数据包")]
    public class ProgressLogicPacketHandler : IServerPacketHandler
    {
        public int HandlePacket(ServerConnector connector, GamePacket packet)
        {
            connector.HandlePacket(packet.Code, packet);

            return 0;
        }
    }
}
