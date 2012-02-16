using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;

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
    }
}
