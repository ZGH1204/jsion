using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ServerCommon.Jsion.Packets;

namespace GameServer.Interfaces
{
    interface ICenterPackageSendLib
    {
        void SendTCP(JSNPackageIn pkg);



    }
}
