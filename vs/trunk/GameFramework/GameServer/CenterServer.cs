using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ServerCommon.Jsion.Server;
using GameServer.Packages;
using ServerCommon.Jsion.Packets;
using Jsion.NetWork.Packet;
using GameServer.Managers;

namespace GameServer
{
    public class CenterServer : ServerConnector
    {
        private CenterPackageSendLib m_sendOut;
        private CenterPackageHandlers processor;

        public CenterPackageSendLib SendOut { get { return m_sendOut; } }

        public CenterServer(string name)
            : base(name, GSConfigMgr.Configuration.ServerConnectTryTimes)
        {

        }

        protected override void OnConnected(bool successed)
        {
            if (successed)
            {
                Console.WriteLine(Name + "连接成功!\r\n");
            }
            base.OnConnected(successed);
        }

        protected override void Init()
        {
            m_sendOut = new CenterPackageSendLib(this);
            processor = new CenterPackageHandlers(this);
        }

        protected override void ReceivePackage(Package pkg)
        {
            base.ReceivePackage(pkg);
        }

        private static readonly object LockHelper = new object();
        protected override void AsynProcessPacket(object state)
        {
            lock (LockHelper)
            {
                JSNPackageIn pkg = state as JSNPackageIn;
                processor.HandlerPackage(pkg as JSNPackageIn);
            }
        }
    }
}
