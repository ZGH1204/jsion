using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using System.Net.Sockets;

namespace CacheServer
{
    public class CacheSrv : ServerBase
    {
        public CacheSrv()
            : base()
        { }

        protected override ClientBase CreateClient(Socket socket)
        {
            CacheClient client = new CacheClient();

            client.Accept(socket);

            return client;
        }

        private static readonly CacheSrv m_server = new CacheSrv();

        public static CacheSrv Server { get { return m_server; } }
    }
}
