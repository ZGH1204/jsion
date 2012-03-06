using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;

namespace GatewayServer.Packets.ServerHandlers
{
    [PacketHandler((int)BasePacketCode.Logic_Code, "处理其他服务器从网关转发给逻辑服务器的数据包")]
    public class ProcessLogicPkgHandler : IServerPacketHandler
    {
        public int HandlePacket(ServerConnector connector, GamePacket packet)
        {
            GatewayPlayer player = GatewayGlobal.Players[packet.PlayerID];

            player.Client.LogicServer.SendTCP(packet);

            return 0;
        }
    }
}
