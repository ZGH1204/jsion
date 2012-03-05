using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;

namespace GameBase.Packets
{
    public interface IPacketHandler
    {
        int HandlePacket(ClientBase client, GamePacket packet);
    }
}
