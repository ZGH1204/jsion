using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using System.Net.Sockets;
using System.Threading;

namespace GatewayServer
{
    public class GatewaySrv : ServerBase
    {
        private object m_locker;

        public GatewaySrv()
            : base()
        {
            m_locker = new object();
        }

        protected override ClientBase CreateClient(Socket socket)
        {
            GatewayClient client = new GatewayClient();

            client.Accept(socket);

            lock (m_locker)
            {
                GatewayGlobal.ClientCount++;

                client.ClientID = GatewayGlobal.ClientCount;
            }

            return client;
        }

        protected override void SaveClient(ClientBase client)
        {
            base.SaveClient(client);
        }

        private static readonly GatewaySrv m_server = new GatewaySrv();

        public static GatewaySrv Server { get { return m_server; } }
    }
}
