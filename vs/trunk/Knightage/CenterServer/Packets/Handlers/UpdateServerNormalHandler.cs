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
    [PacketHandler((int)BasePacketCode.UpdateServerNormal, "更新网关服务器为正常状态")]
    public class UpdateServerNormalHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            int gatewayID = packet.ReadInt();

            GatewayInfo info = CenterGlobal.GatewayMgr.FindTemplate(gatewayID);

            info.Fulled = false;

            return 0;
        }
    }
}
