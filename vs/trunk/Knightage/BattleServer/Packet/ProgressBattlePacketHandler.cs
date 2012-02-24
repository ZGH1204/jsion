using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase.Net;
using GameBase;

namespace BattleServer.Packets
{
    [PacketHandler((int)BasePacketCode.Battle_Code, "处理逻辑服务器的数据包")]
    public class ProgressBattlePacketHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            client.HandlePacket(packet.Code, packet);

            return 0;
        }
    }
}
