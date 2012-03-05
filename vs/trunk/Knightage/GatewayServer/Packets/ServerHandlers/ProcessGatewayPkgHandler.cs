using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;

namespace GatewayServer.Packets.ServerHandlers
{
    [PacketHandler((int)BasePacketCode.Gateway_Code, "处理其他服务器发给网关的数据包")]
    public class ProcessGatewayPkgHandler : IServerPacketHandler
    {
        public int HandlePacket(ServerConnector connector, GamePacket packet)
        {
            connector.HandlePacket(packet.Code, packet);

            return 0;
        }
    }
}
