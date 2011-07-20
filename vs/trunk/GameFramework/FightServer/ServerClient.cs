using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Sockets;
using FightServer.Packages;
using FightServer.Interfaces;
using ServerCommon.Jsion.Client;
using ServerCommon.Jsion.Packets;

namespace FightServer
{
    public class ServerClient : ClientBase
    {
        protected PackageSendLib m_sendOut;
        protected PackageHandlers processor;

        public PackageSendLib SendOut { get { return m_sendOut; } }

        public ServerClient(Socket sock)
            :base(sock)
        {

        }

        public ServerClient(Socket sock, byte[] sBuffer, byte[] rBuffer)
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
