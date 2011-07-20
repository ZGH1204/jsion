using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Jsion.Utils;

namespace FightServer.Managers
{
    public class FSConfigMgr
    {
        public static FightServerConfig Configuration { get; set; }

        public static void CreateConfig()
        {
            Configuration = new FightServerConfig();
            Configuration.Refresh();
        }

        //public static void LoadGameServerConfig(string file)
        //{
        //    Configuration = SerializationUtil.Load(typeof(CenterServerConfig), file) as CenterServerConfig;
        //}
    }
}
