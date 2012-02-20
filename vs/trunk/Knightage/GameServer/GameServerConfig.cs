using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using AppConfig;

namespace GameServer
{
    public class GameServerConfig : ServerConfig
    {
        public static GameServerConfig Configuration { get; protected set; }

        static GameServerConfig()
        {
            Configuration = new GameServerConfig();

            Configuration.Load();
        }

        [AppConfig("CenterIP", "中心服务器IP", "127.0.0.1")]
        public string CenterIP;

        [AppConfig("CenterPort", "中心服务器端口", 9000)]
        public int CenterPort;
    }
}
