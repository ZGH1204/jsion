using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JUtils.Net;

namespace GameCore
{
    public class Server : JSocket
    {
        public override Packet UsedPacket
        {
            get
            {
                return new Package();
            }
        }
    }
}
