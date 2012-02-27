using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Managers;
using GameBase;

namespace GatewayServer
{
    public class GatewayGlobal
    {
        public static uint GatewayID = 0;

        public static uint ClientCount = 0;

        public static CenterServerConnector CenterServer;

        public static CacheServerConnector CacheServer;

        public static readonly ObjectMgr<GatewayClient> PlayerClientMgr = new ObjectMgr<GatewayClient>();

        public static readonly ObjectMgr<GatewayClient> PlayerLoginMgr = new ObjectMgr<GatewayClient>();

        public static readonly ObjectMgr<ServerConnector> ConnectingMgr = new ObjectMgr<ServerConnector>();

        public static readonly ObjectMgr<GameLogicServerConnector> GameLogicServerMgr = new ObjectMgr<GameLogicServerConnector>();

        public static readonly ObjectMgr<BattleServerConnector> BattleServerMgr = new ObjectMgr<BattleServerConnector>();

        public static bool ContainsGameLogicServer(uint id)
        {
            if (id <= 0)
            {
                throw new ArgumentOutOfRangeException("id");
            }

            GameLogicServerConnector connector = ConnectingMgr[id] as GameLogicServerConnector;

            if (connector != null) return true;

            return GameLogicServerMgr.Contains(id);
        }

        public static bool ContainsBattleServer(uint id)
        {
            BattleServerConnector connector = ConnectingMgr[id] as BattleServerConnector;

            if (connector != null) return true;

            return BattleServerMgr.Contains(id);
        }
    }
}
