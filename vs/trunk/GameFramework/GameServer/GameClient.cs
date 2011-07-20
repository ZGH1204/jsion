using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Sockets;
using GameServer.Packages;
using ServerCommon.Jsion.Client;
using ServerCommon.Jsion.Packets;

namespace GameServer
{
    public class GameClient : ClientBase
    {
        protected PackageSendLib m_sendOut;
        protected PackageHandlers processor;

        public PackageSendLib SendOut { get { return m_sendOut; } }

        public GameClient(Socket sock)
            :base(sock)
        {

        }

        public GameClient(Socket sock, byte[] sBuffer, byte[] rBuffer)
            :base(sock, sBuffer, rBuffer)
        {

        }

        protected override void Init()
        {
            m_sendOut = new PackageSendLib(this);
            processor = new PackageHandlers(this);
        }

        protected override void OnReceivePackage(Jsion.NetWork.Packet.Package pkg)
        {
            processor.HandlerPackage(pkg as JSNPackageIn);
        }
    }
}
