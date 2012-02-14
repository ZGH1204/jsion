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

        private static GameSrv m_server;

        public static GameSrv Server
        {
            get
            {
                if (m_server == null)
                {
                    m_server = new GameSrv();
                }

                return m_server;
            }
        }
    }
}
