using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NetWorkLib.Interfaces;
using Jsion.NetWork.Packet;
using Jsion.NetWork.Sockets;

namespace Jsion.NetWork.Readers
{
    [Obsolete("不再需要使用此类，已整合")]
    public class PackageReader : IPackageReader
    {
        public Package ReadPackage(int pkgSize, byte[] srcBuffer, int srcOffset, int len)
        {
            return null;
        }


        public Package ReadPackage(ref int srcOffset, ref int pkgLength, int curBufferSize, byte[] srcBuffer, ByteSocket sock)
        {
            short header = 0;

            while (srcOffset + 4 < curBufferSize)
            {
                header = (short)((srcBuffer[srcOffset] << 8) + srcBuffer[srcOffset + 1]);
                if (header == Package.HEADER)
                {
                    pkgLength = (srcBuffer[srcOffset + 2] << 8) + srcBuffer[srcOffset + 3];
                    break;
                }
                else
                {
                    srcOffset++;
                }
            }

            int dataLeft = curBufferSize - srcOffset;

            if ((pkgLength != 0 && pkgLength < Package.HDR_SIZE) || pkgLength > sock.ReceiveBufferSize)
            {
                return null;
            }

            if (dataLeft >= pkgLength && pkgLength != 0)
            {
                Package pkg = sock.ReceiveUsedPacket;
                pkg.CopyFrom(srcBuffer, srcOffset, 0, pkgLength);
                return pkg;
            }

            return null;
        }
    }
}
