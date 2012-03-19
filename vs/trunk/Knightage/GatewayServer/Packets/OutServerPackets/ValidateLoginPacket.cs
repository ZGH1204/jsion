using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase;

namespace GatewayServer.Packets.OutServerPackets
{
    public class ValidateLoginPacket : CenterPacket
    {
        public ValidateLoginPacket()
            : base(BasePacketCode.ValidateLogin)
        {

        }

        public int ClientID { get; set; }

        public string Account { get; set; }

        public override void WriteData()
        {
            WriteInt(ClientID);

            WriteUTF(Account);
        }
    }
}
