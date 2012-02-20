using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using System.Net.Sockets;

namespace GatewayServer
{
    public class GatewaySrv : ServerBase
    {
        public GatewaySrv()
            : base()
        { }

        protected override ClientBase CreateClient(Socket socket)
        {
            GatewayClient client = new GatewayClient();

            client.Accept(socket);

            return client;
        }

        private static readonly GatewaySrv m_server = new GatewaySrv();

        public static GatewaySrv Server { get { return m_server; } }
    }
}
