using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;

namespace GameServer
{
    public class GameGlobal
    {
        public static readonly CenterServerConnector CenterServer = new CenterServerConnector(ServerType.LogicServer, GameServerConfig.Configuration.Port);
    }
}
