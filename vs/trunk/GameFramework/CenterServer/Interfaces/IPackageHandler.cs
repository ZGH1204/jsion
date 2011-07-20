using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ServerCommon.Jsion.Packets;

namespace CenterServer.Interfaces
{
    interface IPackageHandler
    {
        int HandlePacket(ServerClient client, JSNPackageIn pkg);
    }
}
