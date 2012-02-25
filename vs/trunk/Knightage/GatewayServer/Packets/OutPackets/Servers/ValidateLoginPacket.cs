using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase;

namespace GatewayServer.Packets.OutPackets.Servers
{
    public class ValidateLoginPacket : CenterPacket
    {
        public ValidateLoginPacket()
            : base(BasePacketCode.ValidateLogin)
        { }

        public uint ClientID { get; set; }

        public string Account { get; set; }

        public override void WriteData()
        {
            WriteUnsignedInt(ClientID);
            WriteUTF(Account);
        }
    }
}
