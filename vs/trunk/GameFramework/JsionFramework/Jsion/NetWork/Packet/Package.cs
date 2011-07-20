using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Jsion.Contants;

namespace Jsion.NetWork.Packet
{
    public class Package : ByteArray
    {
        public Package():base()
        {
            ResetOffset();
        }

        public Package(int minSize, EndianEnum endianEnum):base(minSize, endianEnum)
        {
            ResetOffset();
        }

        public static int HDR_SIZE { get { return 14; } }
        public static short HEADER { get { return short.MinValue; } }

        public int Code { get; set; }

        public int Extend1 { get; set; }

        public int Extend2 { get; set; }

        public virtual void ResetOffset()
        {
            postion = HDR_SIZE;
        }

        public virtual Package Clone()
        {
            Package pkg = new Package(size, endian);

            pkg.CopyFrom(Buffer, 0, 0, size);

            pkg.ReadHeader();

            postion = dataLength;

            return pkg;
        }

        public virtual void ReadHeader() { }

        public virtual void WriteHeader() { }
    }
}
