using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;
using GameBase.ServerConfigs;

namespace CenterServer.Packets.Handlers
{
    [PacketHandler((int)BasePacketCode.UpdateServerFull, "更新网关服务器为满载状态")]
    public class UpdateServerFullHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            uint gatewayID = packet.ReadUnsignedInt();

            uint clientID = packet.ReadUnsignedInt();

            GatewayInfo info = CenterGlobal.GatewayMgr.FindTemplate(gatewayID);

            info.Fulled = true;

            ConnectOtherGatewayHandler.ConnectOtherGatewayServer(client, gatewayID, clientID);

            return 0;
        }
    }
}
