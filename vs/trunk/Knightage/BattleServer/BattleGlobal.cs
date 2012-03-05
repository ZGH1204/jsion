using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;

namespace BattleServer
{
    public class BattleGlobal
    {
        public static readonly CenterServerConnector CenterServer = new CenterServerConnector(ServerType.BattleServer, BattleServerConfig.Configuration.Port);
    }
}
