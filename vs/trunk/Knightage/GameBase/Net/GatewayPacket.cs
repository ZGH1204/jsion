using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GameBase.Net
{
    public class GatewayPacket : GamePacket
    {
        public GatewayPacket(BasePacketCode code)
            : base(code, BasePacketCode.Gateway_Code)
        { }
    }
}
