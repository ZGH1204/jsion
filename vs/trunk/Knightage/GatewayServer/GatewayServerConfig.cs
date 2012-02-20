using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;

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
    }
}
