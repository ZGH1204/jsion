using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase.Net;

namespace GameServer
{
    public class GamePacketHandlers : PacketHandlers
    {
        //private GameClient gameClient;

        public GamePacketHandlers(GameClient gameClient)
            : base(gameClient)
        {
            // TODO: Complete member initialization
            //this.gameClient = gameClient;
        }
        //public override void HandlePacket(GamePacket packet)
        //{
        //    if (packet != null && packet.Code2 != 0 && packet.Code <= 1000)
        //    {
        //        return;
        //    }

        //    base.HandlePacket(packet);
        //}

        public override void HandlePacket(int code, GamePacket packet)
        {
            if (packet != null && packet.Code2 != 0 && packet.Code <= 1000)
            {
                return;
            }

            base.HandlePacket(code, packet);
        }
    }
}
