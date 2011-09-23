using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Net;

namespace GameBase.Net
{
    public class GamePacket : Packet
    {
        #region 构造函数

        public GamePacket()
            : base()
        { }

        public GamePacket(int bufferSize)
            : base(bufferSize)
        { }

        public GamePacket(int bufferSize, EndianEnum endian)
            : base(bufferSize, endian)
        { }

        public GamePacket(byte[] buff, EndianEnum endian)
            : base(buff, endian)
        { }

        #endregion

        public int Code { get; set; }

        public override int HeaderSize { get { return 6; } }
        public override int PkgLenOffset { get { return 0; } }

        public override void ReadHeader()
        {
            //base.ReadHeader();

            Position = 0;

            Length = ReadShort();

            Code = ReadInt();
        }

        public override void WriteHeader()
        {
            base.WriteHeader();

            Position = 0;

            WriteShort((short)Length);

            WriteInt(Code);
        }

        public override void Pack()
        {
            //base.Pack();

            Position = 0;

            WriteShort((short)Length);
        }

        public void ClearContext()
        {
            Position = HeaderSize;
            Length = HeaderSize;
        }

        public GamePacket Clone()
        {
            GamePacket packet = new GamePacket(Buffer, Endian);

            packet.ReadHeader();

            //packet.Reset();

            return packet;
        }
    }
}
