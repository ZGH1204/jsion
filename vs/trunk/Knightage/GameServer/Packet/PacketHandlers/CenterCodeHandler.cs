using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;
using GameBase.Managers;

namespace GameServer.Packet.PacketHandlers
{
    [PacketHandler((int)BasePacketCode.Center_Code, "转发数据包到中心服务器")]
    public class CenterCodeHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            ServerMgr.Instance.SendToAllServer(packet);

            return 0;
        }
    }
}
