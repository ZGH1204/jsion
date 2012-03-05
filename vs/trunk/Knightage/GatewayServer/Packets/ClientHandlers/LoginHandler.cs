using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;

namespace GatewayServer.Packets.ClientHandlers
{
    [PacketHandler((int)BasePacketCode.Login, "分配逻辑服务器并重新打包登陆数据包")]
    public class LoginHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            GatewayClient gc = client as GatewayClient;

            string account = packet.ReadUTF();

            return 0;
        }
    }
}
