using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using GameBase.Datas;

namespace GameServer
{
    public class GamePlayer : Player
    {
        public GamePlayer(PlayerInfo info, GameClient client)
            : base(info, client)
        { }

        public new GameClient Client { get; protected set; }
    }
}
