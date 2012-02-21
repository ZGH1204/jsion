using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Managers;

namespace CenterServer
{
    public class CenterGlobal
    {
        public static readonly ObjectMgr<CenterClient> GatewayServerMgr = new ObjectMgr<CenterClient>();
        public static readonly ObjectMgr<CenterClient> GameLogicServerMgr = new ObjectMgr<CenterClient>();
        public static readonly ObjectMgr<CenterClient> BattleServerMgr = new ObjectMgr<CenterClient>();
    }
}
