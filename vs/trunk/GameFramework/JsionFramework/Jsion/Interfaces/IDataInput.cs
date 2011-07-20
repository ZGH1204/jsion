using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Jsion.Interfaces
{
    /// <summary>
    /// IDataInput 接口提供一组用于读取二进制数据的方法。 此接口是写入二进制数据的 IDataOutput 接口的 I/O 对应接口。
    /// </summary>
    public interface IDataInput : IDataIO
    {
        /// <summary>
        /// 从字节流中读取布尔值。读取单个字节，如果字节非零，则返回 true，否则返回 false。
        /// </summary>
        /// <returns>如果字节不为零，则返回 true，否则返回 false。</returns>
        /// <exception cref="没有足够的数据可供读取，引发数组超出索引。"></exception>
        Boolean readBoolean();
        /// <summary>
        /// 从字节流中读取带符号的字节。 
        /// </summary>
        /// <returns>返回值的范围是从 -128 到 127。</returns>
        /// <exception cref="没有足够的数据可供读取，引发数组超出索引。"></exception>
        sbyte readByte();
        /// <summary>
        /// 从字节流中读取 length 参数指定的数据字节数。
        /// 从 offset 指定的位置开始，将字节读入 bytes 参数指定的 ByteArray 对象中，并将字节写入目标 ByteArray 中。
        /// </summary>
        /// <param name="bytes">要将数据读入的 ByteArray 对象。</param>
        /// <param name="offset">bytes 中的偏移（位置），应从该位置写入读取的数据。从零开始的索引</param>
        /// <param name="length">要读取的字节数。默认值 0 导致读取所有可用的数据。</param>
        /// <returns> length 参数指定长度的字节数组</returns>
        /// <exception cref="没有足够的数据可供读取，引发数组超出索引。"></exception>
        byte[] readBytes(int length = 0);
        /// <summary>
        /// 从字节流或字节数组中读取 IEEE 754 双精度浮点数。
        /// </summary>
        /// <returns>双精度（64 位）浮点数。</returns>
        /// <exception cref="没有足够的数据可供读取，引发数组超出索引。"></exception>
        double readDouble();
        /// <summary>
        /// 从字节流或字节数组中读取 IEEE 754 单精度浮点数。
        /// </summary>
        /// <returns>单精度浮点数。</returns>
        /// <exception cref="没有足够的数据可供读取，引发数组超出索引。"></exception>
        float readFloat();
        /// <summary>
        /// 从字节流或字节数组中读取带符号的 32 位整数。
        /// </summary>
        /// <returns>带符号的 32 位整数。</returns>
        /// <exception cref="没有足够的数据可供读取，引发数组超出索引。"></exception>
        int readInt();
        /// <summary>
        /// 从字节流或字节数组中读取带符号的 16 位整数。
        /// </summary>
        /// <returns>带符号的 16 位整数。</returns>
        /// <exception cref="没有足够的数据可供读取，引发数组超出索引。"></exception>
        short readShort();
        /// <summary>
        /// 从字节流或字节数组中读取无符号的字节。
        /// </summary>
        /// <returns>无符号的字节。</returns>
        /// <exception cref="没有足够的数据可供读取，引发数组超出索引。"></exception>
        byte readUnsignedByte();
        /// <summary>
        /// 从字节流或字节数组中读取无符号 32 位整数。
        /// </summary>
        /// <returns>无符号 32 位整数。</returns>
        /// <exception cref="没有足够的数据可供读取，引发数组超出索引。"></exception>
        uint readUnsignedInt();
        /// <summary>
        /// 从字节流或字节数组中读取无符号 16 位整数。
        /// </summary>
        /// <returns>无符号 16 位整数。</returns>
        ushort readUnsignedShort();
        /// <summary>
        /// 从字节流或字节数组中读取 UTF-8 字符串。
        /// </summary>
        /// <returns> UTF-8 字符串。</returns>
        string readUTF();
        /// <summary>
        /// 从字节流或字节数组中读取日期时间。
        /// </summary>
        /// <returns>日期时间</returns>
        DateTime readDate();
    }
}
