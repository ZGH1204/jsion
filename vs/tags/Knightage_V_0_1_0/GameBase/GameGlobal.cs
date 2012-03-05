using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.ServerConfigs;
using GameBase.Managers;

namespace GameBase
{
    public class GameGlobal
    {
        public static readonly TemplateMgr<GatewayInfo> GatewayMgr = new TemplateMgr<GatewayInfo>();
        public static readonly TemplateMgr<GameLogicInfo> GameLogicMgr = new TemplateMgr<GameLogicInfo>();
        public static readonly TemplateMgr<BattleInfo> BattleMgr = new TemplateMgr<BattleInfo>();
    }
}
