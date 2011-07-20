using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Jsion.NetWork.Processors;
using Jsion.NetWork.Sockets;

namespace ServerCommon.Jsion.Packets
{
    public class JSNPkgProcessor : PackageProcessor
    {
        public JSNPkgProcessor(ByteSocket socket, byte[] sBuffer, byte[] rBuffer)
            :base(socket, sBuffer, rBuffer)
        {

        }
    }
}
