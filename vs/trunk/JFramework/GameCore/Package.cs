using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JUtils.Net;

namespace GameCore
{
    public class Package : Packet
    {
        #region 数据包包头属性

        public short Code { get; set; }
        public short SecondCode { get; set; }
        public int Extend1 { get; set; }
        public int Extend2 { get; set; }

        #endregion

        #region 构造函数

        public Package()
        {

        }

        public Package(Packet pkg)
        {
            if (pkg != null)
            {
                CopyFrom(pkg.Buffer, 0, 0, pkg.Length);
                ReadHeader();
                ReadData();
            }
        }

        #endregion

        #region 数据包包头结构

        public override int HeaderSize { get { return 14; } }

        public override void ReadHeader()
        {
            Position = 0;
            ReadShort();
            Code = ReadShort();
            SecondCode = ReadShort();
            Extend1 = ReadInt();
            Extend2 = ReadInt();
        }

        public override void WriteHeader()
        {
            Position = 0;
            WriteShort((short)Length);
            WriteShort(Code);
            WriteShort(SecondCode);
            WriteInt(Extend1);
            WriteInt(Extend2);
        }

        #endregion

        #region 数据包数据读取/写入/打包

        public override void Pack()
        {
            Position = 0;
            WriteShort((short)Length);
            Position = 0;
        }

        public void ReadData()
        {

        }

        public override void WriteData()
        {

        }

        #endregion
    }
}
