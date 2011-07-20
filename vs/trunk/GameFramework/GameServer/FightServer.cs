using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ServerCommon.Jsion.Server;
using GameServer.Packages;
using Jsion.NetWork.Packet;
using ServerCommon.Jsion.Packets;
using GameServer.Managers;

namespace GameServer
{
    public class FightServer : ServerConnector
    {
        private FightPackageSendLib m_sendOut;
        private FightPackageHandlers processor;

        public FightPackageSendLib SendOut { get { return m_sendOut; } }

        public FightServer(string name)
            : base(name, GSConfigMgr.Configuration.ServerConnectTryTimes)
        {

        }

        protected override void OnConnected(bool successed)
        {
            if (successed)
            {
                FightServerMgr.AddServer(this);
                Console.WriteLine(Name + "连接成功!\r\n");
            }
            base.OnConnected(successed);
        }

        protected override void OnDisconnect()
        {
            FightServerMgr.RemoveServer(this);
        }

        protected override void Init()
        {
            m_sendOut = new FightPackageSendLib(this);
            processor = new FightPackageHandlers(this);
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
