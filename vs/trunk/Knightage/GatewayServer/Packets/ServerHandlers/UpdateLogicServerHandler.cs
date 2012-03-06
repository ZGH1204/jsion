using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;

namespace GatewayServer.Packets.ServerHandlers
{
    [PacketHandler((int)BasePacketCode.UpdateServerFull, "更新逻辑服务器已满")]
    public class UpdateLogicServerFullHandler : IServerPacketHandler
    {
        public int HandlePacket(ServerConnector connector, GamePacket packet)
        {
            LogicServerConnector conn = connector as LogicServerConnector;

            if (conn != null)
            {
                conn.Fulled = true;
            }

            return 0;
        }
    }

    [PacketHandler((int)BasePacketCode.UpdateServerNormal, "更新逻辑服务器空闲")]
    public class UpdateLogicServerNormalHandler : IServerPacketHandler
    {
        public int HandlePacket(ServerConnector connector, GamePacket packet)
        {
            LogicServerConnector conn = connector as LogicServerConnector;

            if (conn != null)
            {
                conn.Fulled = false;
            }

            return 0;
        }
    }
}
