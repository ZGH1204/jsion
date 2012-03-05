using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GameBase.Net
{
    public class LogicPacket : GamePacket
    {
        public LogicPacket(BasePacketCode code)
            : base(code, BasePacketCode.None_Code)
        {

        }
    }
}
