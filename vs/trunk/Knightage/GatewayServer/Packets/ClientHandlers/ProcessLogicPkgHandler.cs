using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;

namespace GatewayServer.Packets.ClientHandlers
{
    [PacketHandler((int)BasePacketCode.Logic_Code, "转发客户端逻辑数据包到玩家所在的逻辑服务器")]
    public class ProcessLogicPkgHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            GatewayClient gc = client as GatewayClient;

            if (GatewayGlobal.Players.Contains(gc.PlayerID) && gc.PlayerID == packet.PlayerID)
            {
                gc.LogicServer.SendTCP(packet);
            }

            return 0;
        }
    }
}
