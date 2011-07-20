using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ServerCommon.Jsion.Packets;
using ServerCommon.Jsion.Server;

namespace GameServer.Interfaces
{
    public interface IFightPackageHandler
    {
        int HandlePacket(ServerConnector server, JSNPackageIn pkg);
    }
}
