using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Managers;
using GameBase;

namespace CacheServer
{
    public class CacheGlobal
    {
        public static CenterServerConnector CenterServer;

        public static readonly LoginMgr<string, Player> LoginPlayerMgr = new LoginMgr<string, Player>();

        public static readonly ObjectMgr<Player> CachePlayerMgr = new ObjectMgr<Player>();
    }
}
