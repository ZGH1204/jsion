using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Net
{
    public class Packet : ByteArray
    {
        #region 配置属性

        public virtual int HeaderSize { get { return 4; } }
        public virtual int PkgLenOffset { get { return 0; } }

        #endregion

        #region 构造函数

        public Packet()
            : base()
        { }

        public Packet(int bufferSize)
            : base(bufferSize)
        { }

        public Packet(int bufferSize, EndianEnum endian)
            : base(bufferSize, endian)
        { }

        public Packet(byte[] buff, EndianEnum endian)
            : base(buff, endian)
        { }

        #endregion

        #region 数据包函数

        public virtual void ReadHeader()
        { }

        public virtual void WriteHeader()
        { }

        public virtual void WriteData()
        { }

        public virtual void Pack()
        { }

        #endregion
    }
}
