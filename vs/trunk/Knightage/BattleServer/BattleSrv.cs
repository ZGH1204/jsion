using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;

namespace BattleServer
{
    public class BattleSrv : ServerBase
    {
        public BattleSrv()
            : base()
        {

        }

        protected override ClientBase CreateClient(System.Net.Sockets.Socket socket)
        {
            BattleClient client = new BattleClient();

            client.Accept(socket);

            return client;
        }

        private static readonly BattleSrv m_server = new BattleSrv();

        public static BattleSrv Server { get { return m_server; } }
    }
}
