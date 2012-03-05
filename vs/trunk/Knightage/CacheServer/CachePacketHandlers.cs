using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase.Net;

namespace CacheServer
{
    public class CachePacketHandlers : PacketHandlers
    {
        public CachePacketHandlers(CacheClient client)
            : base(client)
        { }

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
