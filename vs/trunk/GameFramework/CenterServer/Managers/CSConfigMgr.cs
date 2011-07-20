using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Jsion.Utils;

namespace CenterServer.Managers
{
    public class CSConfigMgr
    {
        public static CenterServerConfig Configuration { get; set; }

        public static void CreateConfig()
        {
            Configuration = new CenterServerConfig();
            Configuration.Refresh();
        }

        //public static void LoadGameServerConfig(string file)
        //{
        //    Configuration = SerializationUtil.Load(typeof(CenterServerConfig), file) as CenterServerConfig;
        //}
    }
}
