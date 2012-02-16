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

        #region 协议数据结构

        public int Code { get; set; }

        public int Code2 { get; set; }

        public uint PlayerID { get; set; }

        public override int HeaderSize { get { return 14; } }
        public override int PkgLenOffset { get { return 0; } }

        public override void ReadHeader()
        {
            Position = 0;

            Length = ReadShort();

            Code = ReadInt();

            Code2 = ReadInt();

            PlayerID = ReadUnsignedInt();
        }

        public override void WriteHeader()
        {
            base.WriteHeader();

            Position = 0;

            WriteShort((short)Length);

            WriteInt(Code);

            WriteInt(Code2);

            WriteUnsignedInt(PlayerID);
        }

        public override void Pack()
        {
            Position = 0;

            WriteShort((short)Length);
        }

        #endregion

        /// <summary>
        /// 复制一个数据包,使用同一个字节流.
        /// </summary>
        /// <returns></returns>
        public GamePacket Clone()
        {
            GamePacket packet = new GamePacket(Buffer, Endian);

            packet.ReadHeader();

            return packet;
        }
    }
}
