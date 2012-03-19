using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase;

namespace CenterServer.Packets.OutPackets
{
    public class NoticeRegistePacket : GatewayPacket
    {
        public NoticeRegistePacket()
            : base(BasePacketCode.NoticeRegiste)
        {

        }

        public int ClientID { get; set; }

        public override void WriteData()
        {
            WriteInt(ClientID);
        }
    }
}
