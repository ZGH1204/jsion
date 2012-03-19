using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;

namespace CenterServer.Packets.OutPackets
{
    public class ValidateLoginPacket : GatewayPacket
    {
        public ValidateLoginPacket()
            : base(GameBase.BasePacketCode.ValidateLogin)
        {

        }

        public int ClientID { get; set; }

        public override void WriteData()
        {
            WriteInt(ClientID);
        }
    }
}
