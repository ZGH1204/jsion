using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase;

namespace GameBase.Packets.OutPackets
{
    public class LoginOutPacket : ClientPacket
    {
        public LoginOutPacket()
            : base(BasePacketCode.LoginOut)
        {

        }
    }
}
