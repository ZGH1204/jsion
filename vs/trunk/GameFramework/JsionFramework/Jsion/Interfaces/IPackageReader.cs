using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Jsion.NetWork.Packet;
using Jsion.NetWork.Sockets;

namespace NetWorkLib.Interfaces
{
    [Obsolete("不再使用此接口")]
    public interface IPackageReader
    {
        Package ReadPackage(int pkgSize, byte[] srcBuffer, int srcOffset, int len);
        Package ReadPackage(ref int srcOffset, ref int pkgLength, int curBufferSize, byte[] srcBuffer, ByteSocket sock);
    }
}
