using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ServerCommon.Jsion.Server;
using ServerCommon.Jsion.Packets;

namespace GameServer.Interfaces
{
    interface ICenterPackageHandler
    {
        int HandlePacket(ServerConnector connector, JSNPackageIn pkg);
    }
}
