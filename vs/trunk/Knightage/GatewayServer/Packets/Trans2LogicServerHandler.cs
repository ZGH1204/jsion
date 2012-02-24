using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;

namespace GatewayServer.Packets
{
    [PacketHandler((int)BasePacketCode.Logic_Code, "转发到逻辑服务器")]
    public class Trans2LogicServerHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            GatewayClient c = GatewayGlobal.PlayerLoginMgr[packet.PlayerID];

            if (c != null && c.LogicServer != null)
            {
                c.LogicServer.SendTCP(packet);
            }

            return 0;
        }
    }
}
