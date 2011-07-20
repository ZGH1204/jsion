using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Jsion.Utils;

namespace GameServer.Managers
{
    public class GSConfigMgr
    {
        public static GameServerConfig Configuration { get; set; }

        public static void CreateConfig()
        {
            Configuration = new GameServerConfig();
            Configuration.Refresh();
        }

        //public static void LoadGameServerConfig(string file)
        //{
        //    Configuration = SerializationUtil.Load(typeof(GameServerConfig), file) as GameServerConfig;
        //}
    }
}
