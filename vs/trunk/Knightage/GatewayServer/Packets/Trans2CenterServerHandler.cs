using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;
using GameBase.Managers;

namespace GatewayServer.Packets
{
    [PacketHandler((int)BasePacketCode.Center_Code, "转发到中心服务器")]
    public class Trans2CenterServerHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            if(packet != null) GatewayGlobal.CenterServer.SendTCP(packet);

            return 0;
        }
    }
}
