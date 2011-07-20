using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ServerCommon.Jsion.Packets;

namespace GameServer.Interfaces
{
    public interface IPackageHandler
    {
        int HandlePacket(GameClient client, JSNPackageIn pkg);
    }
}
