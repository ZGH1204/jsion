using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameServer.Interfaces;
using ServerCommon.Jsion.Packets;
using ServerCommon.Jsion.Server;

namespace GameServer.Packages
{
    public class FightPackageSendLib : IFightPackageSendLib
    {
        protected ServerConnector m_connector;

        public FightPackageSendLib(ServerConnector connector)
        {
            m_connector = connector;
        }

        public void SendTCP(JSNPackageIn pkg)
        {
        }
    }
}
