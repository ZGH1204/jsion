using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase.Net;
using GameBase;

namespace GatewayServer.Packets.Handlers.Servers
{
    [PacketHandler((int)BasePacketCode.Gateway_Code, "处理其他服务器发给网关服务器的数据包")]
    public class ProcessGatewayPacketHandler : IServerPacketHandler
    {
        public int HandlePacket(ServerConnector connector, GamePacket packet)
        {
            connector.HandlePacket(packet.Code, packet);

            return 0;
        }
    }
}
