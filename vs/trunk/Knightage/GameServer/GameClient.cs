using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;

namespace GameServer
{
    public class GameClient : ClientBase
    {
        public GameClient()
            : base()
        { }

        public new GamePlayer Player { get; set; }

        protected override void Initialize()
        {
            m_handlers = new GamePacketHandlers(this);
        }
    }
}
