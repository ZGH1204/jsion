using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;

namespace GameServer.Packet.PacketHandlers
{
    [PacketHandler((int)BasePacketCode.ClientDisconnect, "客户端断开连接")]
    public class ClientDisconnectHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            int clientID = packet.ReadInt();

            GamePlayer player = GameGlobal.PlayerMgr[packet.PlayerID];

            if (player != null && player.Client == client && player.ClientID == clientID)
            {
                player.SaveToDatabase();

                GameGlobal.PlayerMgr.Remove(packet.PlayerID);
            }

            return 0;
        }
    }
}
