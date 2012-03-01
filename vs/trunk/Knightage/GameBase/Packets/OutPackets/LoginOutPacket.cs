using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase;

namespace GameBase.Packets.OutPackets
{
    public class LoginOutPacket : GamePacket
    {
        public LoginOutPacket()
            : base(BasePacketCode.LoginOut, BasePacketCode.None_Code)
        {

        }
    }
}
