using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;

namespace GameBase.Packets
{
    public interface IServerPacketHandler
    {
        int HandlePacket(ServerConnector connector, GamePacket packet);
    }
}
