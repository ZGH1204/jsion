using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;

namespace GatewayServer.Packets.ServerHandlers
{
    [PacketHandler((int)BasePacketCode.UpdateServerID, "更新服务器ID")]
    public class UpdateServerIDHandler : IServerPacketHandler
    {
        public int HandlePacket(ServerConnector connector, GamePacket packet)
        {
            int id = packet.ReadUnsignedByte();

            GatewayGlobal.GatewayID = id;

            return 0;
        }
    }
}
