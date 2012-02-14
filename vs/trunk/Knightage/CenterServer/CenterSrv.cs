using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using System.Net.Sockets;

namespace CenterServer
{
    public class CenterSrv : ServerBase
    {
        public CenterSrv()
            : base()
        { }

        protected override ClientBase CreateClient(Socket socket)
        {
            CenterClient client = new CenterClient();

            client.Accept(socket);

            return client;
        }

        private static CenterSrv m_server;

        public static CenterSrv Server
        {
            get
            {
                if (m_server == null)
                {
                    m_server = new CenterSrv();
                }

                return m_server;
            }
        }
    }
}
