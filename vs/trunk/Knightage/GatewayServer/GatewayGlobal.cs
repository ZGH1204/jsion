using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Managers;
using GameBase;
using GameBase.Net;

namespace GatewayServer
{
    public class GatewayGlobal
    {
        public static uint GatewayID = 0;

        public static uint ClientCount = 0;

        public static CenterServerConnector CenterServer;

        public static CacheServerConnector CacheServer;

        public static readonly ObjectMgr<GatewayClient> PlayerClientMgr = new ObjectMgr<GatewayClient>();

        public static readonly ObjectMgr<GatewayPlayer> PlayerLoginMgr = new ObjectMgr<GatewayPlayer>();

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
        public static GameLogicServerConnector GetLogicConnector()
        {
            if (GameLogicServerMgr.Count == 0)
            {
                return null;
            }

            return GameLogicServerMgr.GetFirstObj();
        }

        //public static void Send2LogicServer(GamePacket pkg)
        //{
        //    GatewayPlayer client = GatewayGlobal.PlayerClientMgr[pkg.PlayerID];
        //    GameLogicServerConnector c = GatewayGlobal.GetLogicConnector();

        //    if (c == null)
        //    {
        //        //TODO: 通知客户端没有可用逻辑服务器
        //    }
        //    else
        //    {
        //        client.LogicServer = c;
        //        c.SendTCP(pkg);
        //        c.IncrementCount();
        //    }
        //}

        public static void Send2CacheServer(GamePacket pkg)
        {
            if (CacheServer == null || CacheServer.Socket.Connected == false)
            {
                //TODO: 通知客户端没有可用缓存服务器
                return;
            }

            CacheServer.SendTCP(pkg);
        }
    }
}
