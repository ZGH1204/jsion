using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ServerCommon.Jsion.Packets;
using CenterServer.Packages;

namespace CenterServer.Interfaces
{
    public class PackageSendLib : IPackageSendLib
    {
        protected ServerClient m_serverClient;

        public PackageSendLib(ServerClient client)
        {
            m_serverClient = client;
        }

        public void SendTCP(JSNPackageIn pkg)
        {
            m_serverClient.SendTcp(pkg);
        }
    }
}
