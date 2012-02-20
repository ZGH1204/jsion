using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using AppConfig;

namespace GatewayServer
{
    public class GatewayServerConfig : ServerConfig
    {
        public static GatewayServerConfig Configuration { get; protected set; }

        static GatewayServerConfig()
        {
            Configuration = new GatewayServerConfig();

            Configuration.Load();
        }

        [AppConfig("CenterIP", "中心服务器IP", "127.0.0.1")]
        public string CenterIP;

        [AppConfig("CenterPort", "中心服务器端口", 9000)]
        public int CenterPort;
    }
}
