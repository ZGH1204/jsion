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
        public static readonly ObjectMgr<CenterClient> GatewayServerMgr = new ObjectMgr<CenterClient>();
        public static readonly ObjectMgr<CenterClient> GameLogicServerMgr = new ObjectMgr<CenterClient>();
        public static readonly ObjectMgr<CenterClient> BattleServerMgr = new ObjectMgr<CenterClient>();

        public static readonly LoginMgr<Player> LoginPlayerMgr = new LoginMgr<Player>();

        public static int PlayerCount = 0;


        public static GatewayInfo GetNormalGateway(int exceptID)
        {
            int[] keys = GatewayServerMgr.GetKeys();

            foreach (int id in keys)
            {
                if (id == exceptID)
                {
                    continue;
                }

                GatewayInfo info = GameGlobal.GatewayMgr.FindTemplate(id);

                if (info != null && info.Fulled == false)
                {
                    return info;
                }
            }

            return null;
        }
    }
}
