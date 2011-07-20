using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Jsion.NetWork.Sockets;
using Jsion.NetWork.Processors;
using ServerCommon.Jsion.Packets;
using Jsion.NetWork.Packet;
using JsionFramework.Jsion.Interfaces;

namespace ServerCommon.Jsion
{
    public class SSocket : ByteSocket
    {
        #region 构造函数

        public SSocket(bool asyncSend = true):
            base(asyncSend)
        {

        }
        
        public SSocket(byte[] sBuffer, byte[] rBuffer, bool asyncSend = true):
            base(sBuffer, rBuffer, asyncSend)
        {
        }

        #endregion

        #region 配置重写实现

        public override Package ReceiveUsedPacket
        {
            get
            {
                return new JSNPackageIn(ReceiveBufferSize);
            }
        }

        public override int CanTryTimes
        {
            get
            {
                return 0;
            }
        }

        public override ICrytPackage UsedCrytor
        {
            get
            {
                return new PacketCrytor();
            }
        }

        public override bool Encryted
        {
            get
            {
                return true;
            }
        }

        #endregion
    }
}
