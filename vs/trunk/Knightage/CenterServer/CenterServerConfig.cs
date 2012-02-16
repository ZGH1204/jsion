using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
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
    }
}
