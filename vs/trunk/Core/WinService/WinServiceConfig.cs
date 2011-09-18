using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AppConfig;

namespace WinService
{
    public class WinServiceConfig : AppConfigAbstract
    {
        [AppConfig("SubscriptionPort", "订阅服务端口", 8612)]
        public int SubscriptionPort;

        [AppConfig("ControlPort", "控制服务端口", 8705)]
        public int ControlPort;

        public void Load()
        {
            Load(typeof(WinServiceConfig));
        }

        private static WinServiceConfig Config;

        static WinServiceConfig()
        {
            Config = new WinServiceConfig();
            Config.Load();
        }

        public static WinServiceConfig WinConfig { get { return Config; } }
    }
}
