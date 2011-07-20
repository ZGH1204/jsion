using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using log4net;
using System.Reflection;
using System.Threading;
using Jsion.NetWork.Packet;

namespace ServerCommon.Jsion.Server
{
    public class ServerConnector : ServerBase
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private string m_name;
        private string m_ip;
        private int m_port;

        private int m_tryConnectCount;
        private int m_hasConnectCount = 0;

        public string Name
        {
            get { return m_name; }
        }

        public SSocket Socket 
        {
            get { return m_socket; }
        }

        public ServerConnector(string name, int tryConnectCount)
            :base()
        {
            m_name = name;
            m_tryConnectCount = tryConnectCount;
        }

        public override void Connect(string ip, int port)
        {
            m_ip = ip;
            m_port = port;
            base.Connect(m_ip, m_port);
        }

        public virtual void SendPkg(Package pkg)
        {
            if (m_socket == null) return;

            m_socket.SendPkg(pkg);
        }

        protected override void OnConnected(bool successed)
        {
            if (!successed)
            {
                log.ErrorFormat("{0}连接失败!", m_name);

                m_hasConnectCount++;

                if (m_tryConnectCount > 0 && m_hasConnectCount >= m_tryConnectCount) return;

                System.Threading.Thread.Sleep(1000);

                base.Connect(m_ip, m_port);
            }
            else
            {
                m_hasConnectCount = 0;
            }
        }

        protected override void OnDisconnect()
        {
            base.Connect(m_ip, m_port);
        }

        protected override void ReceivePackage(Package pkg)
        {
            ThreadPool.QueueUserWorkItem(new WaitCallback(AsynProcessPacket), pkg);
        }

        protected virtual void AsynProcessPacket(object state)
        {
        }
    }
}
