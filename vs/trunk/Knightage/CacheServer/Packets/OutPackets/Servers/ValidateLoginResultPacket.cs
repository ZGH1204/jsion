using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase;
using GameBase.Datas;

namespace CacheServer.Packets.OutPackets.Servers
{
    public class ValidateLoginSuccessPacket : GatewayPacket
    {
        public ValidateLoginSuccessPacket()
            : base(BasePacketCode.ValidateLoginResult)
        {

        }

        public uint ClientID { get; set; }

        public PlayerInfo Info { get; set; }

        public override void WriteData()
        {
            WriteBoolean(true);
            WriteUnsignedInt(ClientID);
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
