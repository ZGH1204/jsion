using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Net;

namespace GameBase.Net
{
    public class BattlePacket : GamePacket
    {
        public BattlePacket()
            : base()
        {
            Code2 = (int)BasePacketCode.Battle_Code;
        }

        public BattlePacket(int bufferSize)
            : base(bufferSize)
        {
            Code2 = (int)BasePacketCode.Battle_Code;
        }

        public BattlePacket(int bufferSize, EndianEnum endian)
            : base(bufferSize, endian)
        {
            Code2 = (int)BasePacketCode.Battle_Code;
        }

        public BattlePacket(byte[] buff, EndianEnum endian)
            : base(buff, endian)
        {
            Code2 = (int)BasePacketCode.Battle_Code;
        }
    }
}
