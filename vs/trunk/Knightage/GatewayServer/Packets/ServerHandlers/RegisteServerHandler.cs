using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;

namespace GatewayServer.Packets.ServerHandlers
{
    [PacketHandler((int)BasePacketCode.Registe, "注册失败时中心服务器返回的包 转发给客户端")]
    public class RegisteServerHandler : IServerPacketHandler
    {
        public int HandlePacket(ServerConnector connector, GamePacket packet)
        {
            uint clientID = packet.ReadUnsignedInt();

            GatewayClient client = GatewayGlobal.Clients[clientID];

            if (client != null)
            {
                client.SendTcp(packet);
            }

            return 0;
        }
    }
}
