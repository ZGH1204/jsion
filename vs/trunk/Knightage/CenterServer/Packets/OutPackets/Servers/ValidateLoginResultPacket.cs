using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase;

namespace CenterServer.Packets.OutPackets.Servers
{
    public class ValidateLoginSuccessPacket : GatewayPacket
    {
        public ValidateLoginSuccessPacket()
            : base(BasePacketCode.ValidateLoginResult)
        {

        }

        public uint ClientID { get; set; }

        public string Account { get; set; }

        public override void WriteData()
        {
            WriteBoolean(true);
            WriteUnsignedInt(ClientID);
            WriteUTF(Account);
        }
    }





    public class ValidateLoginFailedPacket : GatewayPacket
    {
        public ValidateLoginFailedPacket()
            : base(BasePacketCode.ValidateLoginResult)
        {

        }

        public uint ClientID { get; set; }

        public override void WriteData()
        {
            WriteBoolean(false);
            WriteUnsignedInt(ClientID);
        }
    }
}
