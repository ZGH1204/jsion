using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Jsion.Contants;

namespace Jsion.Interfaces
{
    public interface IDataIO
    {
        /// <summary>
        /// 数据的字节顺序，为 Endian 类中的“bigEndian”或“littleEndian”常量。
        /// </summary>
        EndianEnum endian { get; set; }
        /// <summary>
        /// 将文件指针的当前位置（以字节为单位）移动或返回到 ByteArray 对象中。
        /// </summary>
        int postion { get; set; }
        /// <summary>
        /// [只读 (read-only)] 返回 ByteArray 对象的长度（以字节为单位）。
        /// </summary>
        int size { get; }
    }
}
