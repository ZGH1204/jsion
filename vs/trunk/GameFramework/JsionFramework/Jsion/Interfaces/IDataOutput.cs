using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Jsion.Interfaces
{
    public interface IDataOutput : IDataIO
    {
        /// <summary>
        /// 写入布尔值。根据 value 参数写入单个字节。如果为 true，则写入 1，如果为 false，则写入 0。
        /// </summary>
        /// <param name="value">确定写入哪个字节的布尔值。如果该参数为 true，则该方法写入 1；如果该参数为 false，则该方法写入 0。</param>
        void writeBoolean(Boolean value);
        /// <summary>
        /// 在字节流中写入一个字节。
        /// </summary>
        /// <param name="value">一个 8 位整数。</param>
        void writeByte(sbyte value);
        /// <summary>
        /// 在字节流中写入一个字节。
        /// </summary>
        /// <param name="value">一个 8 位整数。</param>
        void writeUnsignedByte(byte value);
        /// <summary>
        /// 将指定字节数组 bytes（起始偏移量为 offset，从零开始的索引）中包含 length 个字节的字节序列写入字节流。
        /// 如果省略 length 参数，则使用默认长度 0；该方法将从 offset(从零开始的索引) 开始写入整个缓冲区。如果还省略了 offset 参数，则写入整个缓冲区。
        /// 符号扩展位仅在读取数据时有效，写入数据时无效。 因此，无需单独的写入方法就可以使用 IDataInput.readUnsignedByte() 和 IDataInput.readUnsignedShort()。
        /// </summary>
        /// <param name="value"></param>
        /// <param name="offset">从零开始的索引</param>
        /// <param name="length"></param>
        void writeBytes(byte[] value, int offset = 0, int length = 0);
        /// <summary>
        /// 在字节流中写入一个 IEEE 754 双精度（64 位）浮点数。
        /// </summary>
        /// <param name="value">双精度（64 位）浮点数。</param>
        void writeDouble(double value);
        /// <summary>
        /// 在字节流中写入一个 IEEE 754 单精度（32 位）浮点数。
        /// </summary>
        /// <param name="value">单精度（32 位）浮点数。</param>
        void writeFloat(float value);
        /// <summary>
        /// 在字节流中写入一个带符号的 32 位整数。
        /// </summary>
        /// <param name="value">要写入字节流的整数。</param>
        void writeInt(int value);
        /// <summary>
        /// 在字节流中写入一个无符号的 32 位整数。>
        /// </summary>
        /// <param name="value">要写入字节流的无符号整数。</param>
        void writeUnsignedInt(uint value);
        /// <summary>
        /// 写入一个 16 位整数。
        /// 符号扩展位仅在读取数据时有效，写入数据时无效。 因此，无需单独的写入方法就可以使用 IDataInput.readUnsignedByte() 和 IDataInput.readUnsignedShort()。
        /// </summary>
        /// <param name="value"> 16 位整数。</param>
        void writeShort(short value);
        /// <summary>
        /// 写入一个 16 位整数。
        /// 符号扩展位仅在读取数据时有效，写入数据时无效。 因此，无需单独的写入方法就可以使用 IDataInput.readUnsignedByte() 和 IDataInput.readUnsignedShort()。
        /// </summary>
        /// <param name="value"> 16 位整数。</param>
        void writeUnsignedShort(ushort value);
        /// <summary>
        /// 将 UTF-8 字符串写入字节流。先写入以字节表示的 UTF-8 字符串长度（作为 16 位整数），然后写入表示字符串字符的字节。
        /// </summary>
        /// <param name="value">要写入的字符串值。</param>
        void writeUTF(string value);
        /// <summary>
        /// 将 日期时间 写入字节流。
        /// </summary>
        /// <param name="dt"></param>
        void writeDate(DateTime date);
    }
}
