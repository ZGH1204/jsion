using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using AppConfig;

namespace BattleServer
{
    public class BattleServerConfig : ServerConfig
    {
        public static BattleServerConfig Configuration { get; protected set; }

        static BattleServerConfig()
        {
            Configuration = new BattleServerConfig();

            Configuration.Load();
        }

        [AppConfig("CenterIP", "中心服务器IP", "127.0.0.1")]
        public string CenterIP;

        [AppConfig("CenterPort", "中心服务器端口", 9000)]
        public int CenterPort;
    }
}
