using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;

namespace GatewayServer
{
    public class CenterServerConnector : ServerConnector
    {
        public CenterServerConnector(string ip, int port)
            : base(ip, port)
        { }

        public override string ServerName
        {
            get
            {
                return "中心服务器";
            }
        }
    }
}
