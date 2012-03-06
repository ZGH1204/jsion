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


        //维护网关状态

        private static uint m_freeID;

        public static GatewayInfo GetFreeGateway(uint exceptID)
        {
            GatewayInfo info = GatewayMgr.FindTemplate(m_freeID);

            if (info != null && info.Fulled == false)
            {
                return info;
            }

            m_freeID = GatewayMgr.GetID(gateway => gateway.Fulled == false && gateway.TemplateID != exceptID);

            return GatewayMgr.FindTemplate(m_freeID);
        }


        //已登陆的所有玩家信息

        public static readonly ObjectMgr<uint, CenterPlayer> PlayerMgr = new ObjectMgr<uint, CenterPlayer>();
    }
}
