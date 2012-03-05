using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;

namespace BattleServer
{
    public class BattleClient : ClientBase
    {
        public new BattlePlayer Player { get; set; }

        public BattleClient()
            : base()
        { }
    }
}
