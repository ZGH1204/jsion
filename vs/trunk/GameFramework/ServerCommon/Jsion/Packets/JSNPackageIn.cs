using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Jsion.NetWork.Packet;
using Jsion.Contants;

namespace ServerCommon.Jsion.Packets
{
    public class JSNPackageIn : Package
    {
        public JSNPackageIn(int minSize)
            : base(minSize, EndianEnum.BIG_ENDIAN)
        {

        }

        override public void ReadHeader()
        {
            postion = 0;
            readShort();
            dataLength = readShort();
            Code = readShort();
            Extend1 = readInt();
            Extend2 = readInt();
        }

        override public void WriteHeader()
        {
            postion = 0;
            writeShort(Package.HEADER);
            writeShort((short)dataLength);
            writeShort((short)Code);
            writeInt(Extend1);
            writeInt(Extend2);
        }
    }
}
