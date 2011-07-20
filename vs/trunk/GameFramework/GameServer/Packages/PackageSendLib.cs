using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameServer.Interfaces;
using ServerCommon.Jsion.Packets;

namespace GameServer.Packages
{
    public partial class PackageSendLib : IPackageSendLib
    {
        protected GameClient m_gameClient;

        public PackageSendLib(GameClient client)
        {
            m_gameClient = client;
        }

        public void SendTCP(JSNPackageIn pkg)
        {
            m_gameClient.SendTcp(pkg);
        }
    }
}
