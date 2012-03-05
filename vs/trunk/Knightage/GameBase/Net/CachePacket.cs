using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GameBase.Net
{
    public class CachePacket : GamePacket
    {
        public CachePacket(BasePacketCode code)
            : base(code, BasePacketCode.Cache_Code)
        { }
    }
}
