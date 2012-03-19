using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;

namespace GatewayServer.Packets.ServerHandlers
{
    [PacketHandler((int)BasePacketCode.ConnectLogicServer, "连接逻辑服务器")]
    public class ConnectLogicServerHandler : IServerPacketHandler
    {
        public int HandlePacket(ServerConnector connector, GamePacket packet)
        {
            int id = packet.ReadInt();

            if (GatewayGlobal.BattleServerMgr.Contains(id) ||
                GatewayGlobal.LogicConnectingMgr.Contains(id))
            {
                return 0;
            }

            string ip = packet.ReadUTF();

            int port = packet.ReadInt();

            LogicServerConnector conn = new LogicServerConnector(id);

            conn.Connect(ip, port);

            return 0;
        }
    }
}
