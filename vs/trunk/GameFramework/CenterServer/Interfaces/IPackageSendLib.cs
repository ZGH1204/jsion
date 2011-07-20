using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ServerCommon.Jsion.Packets;

namespace CenterServer.Packages
{
    public interface IPackageSendLib
    {
        void SendTCP(JSNPackageIn pkg);



    }
}
