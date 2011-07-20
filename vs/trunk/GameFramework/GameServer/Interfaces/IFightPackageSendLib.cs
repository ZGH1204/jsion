using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ServerCommon.Jsion.Packets;

namespace GameServer.Interfaces
{
    public interface IFightPackageSendLib
    {
        void SendTCP(JSNPackageIn pkg);


    }
}
