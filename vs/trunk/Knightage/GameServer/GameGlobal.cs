using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using GameBase.Managers;

namespace GameServer
{
    public class GameGlobal
    {
        public static readonly CenterServerConnector CenterServer = new CenterServerConnector(ServerType.LogicServer, GameServerConfig.Configuration.Port);



        public static readonly ObjectMgr<uint, GamePlayer> PlayerMgr = new ObjectMgr<uint, GamePlayer>();
    }
}
