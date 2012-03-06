using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;

namespace GatewayServer.Packets.ServerHandlers
{
    [PacketHandler((int)BasePacketCode.Client_Code, "处理其他服务器从网关服务器对外转发给客户端的数据包")]
    public class ProcessClientPkgHandler : IServerPacketHandler
    {
        public int HandlePacket(ServerConnector connector, GamePacket packet)
        {
            GatewayPlayer player = GatewayGlobal.Players[packet.PlayerID];

            if (player != null)
            {
                player.SendTcp(packet);
            }

            return 0;
        }
    }
}
