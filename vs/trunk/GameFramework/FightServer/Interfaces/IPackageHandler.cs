using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ServerCommon.Jsion.Packets;

namespace FightServer.Interfaces
{
    interface IPackageHandler
    {
        int HandlePacket(ServerClient client, JSNPackageIn pkg);
    }
}
