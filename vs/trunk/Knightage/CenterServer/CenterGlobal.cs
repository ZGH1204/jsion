using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Managers;
using GameBase;
using GameBase.ServerConfigs;

namespace CenterServer
{
    public class CenterGlobal
    {
        public static int PlayerCount = 0;

        public static readonly TemplateMgr<GatewayInfo> GatewayMgr = new TemplateMgr<GatewayInfo>();
        public static readonly TemplateMgr<GameLogicInfo> LogicMgr = new TemplateMgr<GameLogicInfo>();
        public static readonly TemplateMgr<BattleInfo> BattleMgr = new TemplateMgr<BattleInfo>();

        public static readonly ObjectMgr<uint, CenterClient> LogicServerMgr = new ObjectMgr<uint, CenterClient>();
        public static readonly ObjectMgr<uint, CenterClient> GatewayServerMgr = new ObjectMgr<uint, CenterClient>();
        public static readonly ObjectMgr<uint, CenterClient> BattleServerMgr = new ObjectMgr<uint, CenterClient>();
    }
}
