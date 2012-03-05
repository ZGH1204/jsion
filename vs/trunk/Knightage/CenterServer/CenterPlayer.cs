using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using GameBase.Datas;
using CenterServer.Packets.OutPackets;

namespace CenterServer
{
    public class CenterPlayer : Player
    {
        public CenterPlayer(PlayerInfo info, ClientBase client)
            : base(info, client)
        { }

        public override void Logined()
        {
        }
    }
}
