using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using System.Net.Sockets;

namespace GameServer
{
    public class GameSrv : ServerBase
    {
        public GameSrv()
            : base()
        { }

        protected override ClientBase CreateClient(Socket socket)
        {
            GameClient client = new GameClient();

            client.Accept(socket);

            return client;
        }

        private static readonly GameSrv m_server = new GameSrv();

        public static GameSrv Server { get { return m_server; } }
    }
}
