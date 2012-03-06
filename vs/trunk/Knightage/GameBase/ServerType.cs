using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GameBase
{
    public enum ServerType : byte
    {
        UnKnowServer = 0,

        CenterServer = 1,

        LogicServer = 2,

        BattleServer = 3,

        GatewayServer = 4
    }
}
