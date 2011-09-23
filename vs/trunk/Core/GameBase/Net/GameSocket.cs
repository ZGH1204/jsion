using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Net;

namespace GameBase.Net
{
    public class GameSocket : JSocket
    {
        public override Packet UsedPacket { get { return new GamePacket(); } }

        public GameSocket()
            : base()
        { }

        public GameSocket(byte[] sBuff, byte[] rBuff)
            : base(sBuff, rBuff)
        { }
    }
}
