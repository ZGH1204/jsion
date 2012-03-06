using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using GameBase.Datas;

namespace BattleServer
{
    public class BattlePlayer : Player
    {
        public new BattleClient Client { get; protected set; }

        public BattlePlayer(PlayerInfo info, BattleClient client)
            : base(info, client)
        {
            Client = client;
        }
    }
}
