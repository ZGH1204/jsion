using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;

namespace GameBase.Packets.OutPackets
{
    public class ClientMsgPacket : ClientPacket
    {
        public ClientMsgPacket()
            : base(BasePacketCode.Msg)
        {

        }

        public MsgFlag MsgFlag { get; set; }

        public override void WriteData()
        {
            WriteShort((short)MsgFlag);
        }
    }
}
