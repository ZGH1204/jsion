using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;

namespace GatewayServer.Packets.Handlers.Servers
{
    [PacketHandler((int)BasePacketCode.UpdateServerID, "更新网关服务器ID")]
    public class UpdateServerIDHandler : IServerPacketHandler
    {
        public int HandlePacket(ServerConnector connector, GamePacket packet)
        {
            uint id = packet.ReadUnsignedByte();

            GatewayGlobal.GatewayID = id;

            return 0;
        }
    }
}
