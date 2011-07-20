using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameServer.Interfaces;
using ServerCommon.Jsion.Packets;
using ServerCommon.Jsion.Server;

namespace GameServer.Packages
{
    public class CenterPackageSendLib : ICenterPackageSendLib
    {
        protected ServerConnector m_connector;

        public CenterPackageSendLib(ServerConnector connector)
        {
            m_connector = connector;
        }

        public void SendTCP(JSNPackageIn pkg)
        {
            m_connector.SendPkg(pkg);
        }
    }
}
