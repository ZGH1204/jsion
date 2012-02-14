using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;

namespace GameBase
{
    public class ServerConnector : ServerBase
    {
        public ServerConnector(string ip, int port)
            : base(ip, port)
        { }

        public GameSocket Socket 
        {
            get { return m_socket; }
        }

        public string RemoteEndPoint
        {
            get { return m_socket.IP + ":" + m_socket.Port.ToString(); }
        }
    }
}
