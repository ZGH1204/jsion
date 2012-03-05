using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;

namespace GameServer
{
    public class GameClient : ClientBase
    {
        public new GamePlayer Player { get; set; }

        public GameClient()
            : base()
        { }
    }
}
