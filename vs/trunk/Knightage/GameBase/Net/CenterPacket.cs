using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Net;

namespace GameBase.Net
{
    public class CenterPacket : GamePacket
    {
        public CenterPacket(BasePacketCode code)
            : base(code, BasePacketCode.Center_Code)
        { }

        //public CenterPacket(int bufferSize)
        //    : base(bufferSize)
        //{
        //    Code2 = (int)BasePacketCode.Center_Code;
        //}

        //public CenterPacket(int bufferSize, EndianEnum endian)
        //    : base(bufferSize, endian)
        //{
        //    Code2 = (int)BasePacketCode.Center_Code;
        //}

        //public CenterPacket(byte[] buff, EndianEnum endian)
        //    : base(buff, endian)
        //{
        //    Code2 = (int)BasePacketCode.Center_Code;
        //}
    }
}
