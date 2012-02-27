using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AppConfig;
using GameBase;

namespace CenterServer
{
    public class CenterServerConfig : ServerConfig
    {
        public static CenterServerConfig Configuration { get; protected set; }

        static CenterServerConfig()
        {
            Configuration = new CenterServerConfig();

            Configuration.Load();
        }

        [AppConfig("CacheIP", "缓存服务器IP", "127.0.0.1")]
        public string CacheIP;

        [AppConfig("CachePort", "缓存服务器端口", 10000)]
        public int CachePort;
    }
}
