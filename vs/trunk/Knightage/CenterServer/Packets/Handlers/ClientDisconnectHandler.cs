using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;

namespace CenterServer.Packets.Handlers
{
    [PacketHandler((int)BasePacketCode.ClientDisconnect, "客户端断开连接")]
    public class ClientDisconnectHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            uint clientID = packet.ReadUnsignedInt();

            CenterPlayer player = CenterGlobal.PlayerMgr[packet.PlayerID];

            if (player != null && player.Client == client && player.ClientID == clientID)
            {
                CenterGlobal.PlayerMgr.Remove(player.PlayerID);
            }

            return 0;
        }
    }
}
