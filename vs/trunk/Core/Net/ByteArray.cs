using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Net
{
    #region 字节码储存顺序枚举

    /// <summary>
    /// 字节码储存顺序
    /// </summary>
    public enum EndianEnum
    {
        BIG_ENDIAN,
        LITTLE_ENDIAN
    }

    #endregion

    public class ByteArray
    {
        #region 属性/变量

        public int Position { get; set; }

        public byte[] Buffer { get; protected set; }

        public int Length { get; protected set; }

        public EndianEnum Endian { get; protected set; }

        public int BufferSize { get; protected set; }

        #endregion

        #region 构造函数

        public ByteArray()
            : this(2048)
        { }

        public ByteArray(int bufferSize)
            : this(bufferSize, EndianEnum.BIG_ENDIAN)
        { }

        public ByteArray(int bufferSize, EndianEnum endianEnum)
        {
            BufferSize = bufferSize;
            Buffer = new byte[BufferSize];
            Endian = endianEnum;
            Reset();
        }

        public ByteArray(byte[] buff, EndianEnum endianEnum)
        {
            Buffer = buff;
            BufferSize = Buffer.Length;
            Endian = endianEnum;
            Reset();
        }

        #endregion

        #region 其他公共方法

        /// <summary>
        /// 重置字节数组
        /// </summary>
        public void Reset()
        {
            Position = 0;
            Length = 0;
        }

        /// <summary>
        /// 在 src 参数指定的缓冲区中，从 srcOffset 参数指定的位置开始将 count 参数指定的长度
        /// 复制到起始于 offset 参数指定位置的当前 ByteArray 对象缓冲区
        /// </summary>
        /// <param name="src">源缓冲区</param>
        /// <param name="srcOffset"> src 中从零开始的字节偏移量</param>
        /// <param name="offset">当前ByteArray对象缓冲区从零开始的字节偏移量</param>
        /// <param name="count">要复制的字节数，如果超出缓冲区则仅复制有效缓冲区数据</param>
        /// <returns>复制的字节数</returns>
        public virtual int CopyFrom(byte[] src, int srcOffset, int offset, int count)
        {
            var canCopyLen = Math.Min(src.Length - srcOffset, BufferSize - offset);
            count = Math.Min(count, canCopyLen);
            
            if (count > 0)
            {
                System.Buffer.BlockCopy(src, srcOffset, Buffer, offset, count);
                Position = offset + canCopyLen;
                RefreshDataLength();
                Position = 0;
                return count;
            }

            return 0;
        }

        /// <summary>
        /// 将 ByteArray 对象的缓冲区中 offset 参数指定位置开始的缓冲区数据复制到
        /// 起始于 dstOffset 参数指定位置的 dst 参数指定的缓冲区中
        /// </summary>
        /// <param name="dst">要复制到的目标缓冲区</param>
        /// <param name="dstOffset"> dst 中从零开始的字节偏移量</param>
        /// <param name="offset">当前ByteArray对象缓冲区从零开始的字节偏移量</param>
        /// <returns></returns>
        public virtual int CopyTo(byte[] dst, int dstOffset, int offset)
        {
            return CopyTo(dst, dstOffset, Buffer, offset, Length);
        }

        /// <summary>
        /// 将 ByteArray 对象的缓冲区中 offset 参数指定位置开始的缓冲区数据复制到
        /// 起始于 dstOffset 参数指定位置的 dst 参数指定的缓冲区中
        /// </summary>
        /// <param name="dst">要复制到的目标缓冲区</param>
        /// <param name="dstOffset"> dst 中从零开始的字节偏移量</param>
        /// <param name="srcOffset">当前ByteArray对象缓冲区从零开始的字节偏移量</param>
        /// <returns></returns>
        public static int CopyTo(byte[] dst, int dstOffset, byte[] src, int srcOffset, int count)
        {
            int len = Math.Min(dst.Length - dstOffset, count - srcOffset);

            if (len > 0)
            {
                System.Buffer.BlockCopy(src, srcOffset, dst, dstOffset, len);
            }
            else
            {
                len = 0;
            }

            return len;
        }

        #endregion

        #region 读取字节数组方法

        /// <summary>
        /// 读取一个8位有符号整数
        /// </summary>
        /// <returns></returns>
        public sbyte ReadByte()
        {
            if (Position >= Length) throw new Exception("遇到文件尾!");
            return (sbyte)Buffer[Position++];
        }

        /// <summary>
        /// 读取一个8位无符号整数
        /// </summary>
        /// <returns></returns>
        public byte ReadUnsignedByte()
        {
            if (Position >= Length) throw new Exception("遇到文件尾!");
            return (byte)Buffer[Position++];
        }

        /// <summary>
        /// 读取布尔值
        /// </summary>
        /// <returns></returns>
        public bool ReadBoolean()
        {
            if (Position >= Length) throw new Exception("遇到文件尾!");
            return Buffer[Position++] != 0;
        }

        /// <summary>
        /// 读取指定长度的字节数组
        /// </summary>
        /// <param name="len"></param>
        /// <returns></returns>
        public byte[] ReadBytes(int len = 0)
        {
            len = (len <= 0 ? Length - Position : len);

            if ((Position + len) > Length) throw new Exception("遇到文件尾!");

            byte[] bytes = new byte[len];
            Array.Copy(Buffer, Position, bytes, 0, len);
            RefreshBytesByEndian(bytes);
            Position += len;

            return bytes;
        }

        /// <summary>
        /// 读取双精度浮点数
        /// </summary>
        /// <returns></returns>
        public double ReadDouble()
        {
            byte[] bytes = ReadBytes(8);
            return BitConverter.ToDouble(bytes, 0);
        }

        /// <summary>
        /// 读取单精度浮点数
        /// </summary>
        /// <returns></returns>
        public float ReadFloat()
        {
            byte[] bytes = ReadBytes(4);
            return BitConverter.ToSingle(bytes, 0);
        }

        /// <summary>
        /// 读取一个32位有符号整数
        /// </summary>
        /// <returns></returns>
        public int ReadInt()
        {
            byte[] bytes = ReadBytes(4);
            return BitConverter.ToInt32(bytes, 0);
        }

        /// <summary>
        /// 读取一个32位无符号整数
        /// </summary>
        /// <returns></returns>
        public uint ReadUnsignedInt()
        {
            byte[] bytes = ReadBytes(4);
            return BitConverter.ToUInt32(bytes, 0);
        }

        /// <summary>
        /// 读取16位有符号整数
        /// </summary>
        /// <returns></returns>
        public short ReadShort()
        {
            byte[] bytes = ReadBytes(2);
            return BitConverter.ToInt16(bytes, 0);
        }

        /// <summary>
        /// 读取16位无符号整数
        /// </summary>
        /// <returns></returns>
        public ushort ReadUnsignedShort()
        {
            byte[] bytes = ReadBytes(2);
            return BitConverter.ToUInt16(bytes, 0);
        }

        /// <summary>
        /// 读取一个 UTF-8 字符串
        /// </summary>
        /// <returns></returns>
        public string ReadUTF()
        {
            ushort len = ReadUnsignedShort();
            if ((Position + len) > Length) throw new Exception("遇到文件尾!");
            string temp = Encoding.UTF8.GetString(Buffer, Position, len);
            Position += len;
            return temp.Replace("\0", "");
        }

        /// <summary>
        /// 读取一个 DateTime 对象
        /// </summary>
        /// <returns></returns>
        public DateTime ReadDate()
        {
            return new DateTime(ReadShort(), ReadByte(), ReadByte(), ReadByte(), ReadByte(), ReadByte());
        }

        public DateTime ReadShortDate()
        {
            return new DateTime(ReadShort(), ReadByte(), ReadByte(), 0, 0, 0);
        }

        #endregion

        #region 写入字节数组方法

        /// <summary>
        /// 写入一个8位有符号整数
        /// </summary>
        /// <param name="value"></param>
        public void WriteByte(sbyte value)
        {
            WriteUnsignedByte((byte)value);
        }

        /// <summary>
        /// 写入一个8位无符号整数
        /// </summary>
        /// <param name="value"></param>
        public void WriteUnsignedByte(byte value)
        {
            Buffer[Position++] = value;
            RefreshDataLength();
        }

        /// <summary>
        /// 写入一个布尔值
        /// </summary>
        /// <param name="value"></param>
        public void WriteBoolean(bool value)
        {
            WriteUnsignedByte((value ? (byte)1 : (byte)0));
        }

        /// <summary>
        /// 写入字节数组
        /// </summary>
        /// <param name="bytes"></param>
        /// <param name="offset"></param>
        /// <param name="len"></param>
        public void WriteBytes(byte[] bytes, int offset = 0, int len = 0)
        {
            if (len <= 0 || len > (bytes.Length - offset)) len = bytes.Length - offset;

            if (len > (BufferSize - Position)) throw new Exception("写入长度超过字节数组总长度!");

            Array.Copy(bytes, offset, Buffer, Position, len);
            Position += len;
            RefreshDataLength();
        }

        /// <summary>
        /// 写入一个双精度浮点数
        /// </summary>
        /// <param name="value"></param>
        public void WriteDoublie(double value)
        {
            byte[] bytes = BitConverter.GetBytes(value);
            RefreshBytesByEndian(bytes);
            WriteBytes(bytes);
        }

        /// <summary>
        /// 写入一个单精度浮点数
        /// </summary>
        /// <param name="value"></param>
        public void WriteFloat(float value)
        {
            byte[] bytes = BitConverter.GetBytes(value);
            RefreshBytesByEndian(bytes);
            WriteBytes(bytes);
        }

        /// <summary>
        /// 写入一个32位有符号整数
        /// </summary>
        /// <param name="value"></param>
        public void WriteInt(int value)
        {
            byte[] bytes = BitConverter.GetBytes(value);
            RefreshBytesByEndian(bytes);
            WriteBytes(bytes);
        }

        /// <summary>
        /// 写入一个32位无符号整数
        /// </summary>
        /// <param name="value"></param>
        public void WriteUnsignedInt(uint value)
        {
            byte[] bytes = BitConverter.GetBytes(value);
            RefreshBytesByEndian(bytes);
            WriteBytes(bytes);
        }

        /// <summary>
        /// 写入一个16位有符号整数
        /// </summary>
        /// <param name="value"></param>
        public void WriteShort(short value)
        {
            byte[] bytes = BitConverter.GetBytes(value);
            RefreshBytesByEndian(bytes);
            WriteBytes(bytes);
        }

        /// <summary>
        /// 定稿一个16位无符号整数
        /// </summary>
        /// <param name="value"></param>
        public void WriteUnsignedShort(ushort value)
        {
            byte[] bytes = BitConverter.GetBytes(value);
            RefreshBytesByEndian(bytes);
            WriteBytes(bytes);
        }

        /// <summary>
        /// 写入一个 UTF-8 字符串
        /// </summary>
        /// <param name="value"></param>
        public void WriteUTF(string value)
        {
            if (string.IsNullOrEmpty(value))
            {
                WriteShort((short)1);
                WriteUnsignedByte(0x0);
            }
            else
            {
                byte[] bytes = Encoding.UTF8.GetBytes(value);
                WriteShort((short)(bytes.Length + 1));
                WriteBytes(bytes);
                WriteUnsignedByte(0x0);
            }
        }

        public void WriteDate(DateTime date)
        {
            WriteShort((short)date.Year);
            WriteUnsignedByte((byte)date.Month);
            WriteUnsignedByte((byte)date.Day);
            WriteUnsignedByte((byte)date.Hour);
            WriteUnsignedByte((byte)date.Minute);
            WriteUnsignedByte((byte)date.Second);
        }

        public void WriteShortDate(DateTime date)
        {
            WriteShort((short)date.Year);
            WriteUnsignedByte((byte)date.Month);
            WriteUnsignedByte((byte)date.Day);
        }

        #endregion

        #region 压缩/解压缩

        /// <summary>
        /// 使用zlib格式压缩字节流,生成新的对象。
        /// </summary>
        /// <returns></returns>
        public ByteArray Compress()
        {
            byte[] newBuff = Marshal.Compress(Buffer);

            ByteArray ba = new ByteArray(newBuff, Endian);

            return ba;
        }

        /// <summary>
        /// 使用zlib格式解压缩字节流,生成新的对象。
        /// </summary>
        /// <returns></returns>
        public ByteArray Uncompress()
        {
            byte[] newBuff = Marshal.Uncompress(Buffer);

            ByteArray ba = new ByteArray(newBuff, Endian);

            return ba;
        }

        #endregion

        #region 辅助函数

        protected void RefreshDataLength()
        {
            Length = (Position > Length ? Position : Length);
        }

        protected void RefreshBytesByEndian(byte[] bytes)
        {
            if (Endian == EndianEnum.BIG_ENDIAN)
            {
                if (BitConverter.IsLittleEndian)
                {
                    Array.Reverse(bytes);
                }
            }
            else if (Endian == EndianEnum.LITTLE_ENDIAN)
            {
                if (BitConverter.IsLittleEndian == false)
                {
                    Array.Reverse(bytes);
                }
            }
        }

        #endregion
    }
}
