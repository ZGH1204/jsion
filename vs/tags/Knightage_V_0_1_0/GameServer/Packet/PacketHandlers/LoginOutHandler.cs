using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;

namespace GameServer.Packets.Handlers
{
    [PacketHandler((int)BasePacketCode.LoginOut, "玩家登出")]
    public class LoginOutHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            //LogicGlobal.LogicPlayerMgr.Remove(packet.PlayerID);

            return 0;
        }
    }
}
