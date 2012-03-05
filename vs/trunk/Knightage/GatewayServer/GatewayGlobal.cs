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

        public static readonly CenterServerConnector CenterServer = new CenterServerConnector(ServerType.GatewayServer, GatewayServerConfig.Configuration.Port);

        public static readonly ObjectMgr<uint, BattleServerConnector> ConnectingMgr = new ObjectMgr<uint, BattleServerConnector>();

        public static readonly ObjectMgr<uint, BattleServerConnector> BattleServerMgr = new ObjectMgr<uint, BattleServerConnector>();

        public static readonly ObjectMgr<uint, LogicServerConnector> LogicConnectingMgr = new ObjectMgr<uint, LogicServerConnector>();

        public static readonly ObjectMgr<uint, LogicServerConnector> LogicServerMgr = new ObjectMgr<uint, LogicServerConnector>();
    }
}
