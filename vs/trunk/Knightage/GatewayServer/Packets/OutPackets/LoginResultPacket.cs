using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase;

namespace GatewayServer.Packets.OutPackets
{
    public class LoginSuccessPacket : GamePacket
    {
        public LoginSuccessPacket()
            : base(BasePacketCode.Login, BasePacketCode.None_Code)
        {

        }

        public uint PlayerID { get; set; }

        public string NickName { get; set; }

        public override void WriteData()
        {
            WriteBoolean(true);

            WriteUnsignedInt(PlayerID);
            WriteUTF(NickName);
        }
    }





    public class LoginFailedPacket : GamePacket
    {
        public LoginFailedPacket()
            : base(BasePacketCode.Login, BasePacketCode.None_Code)
        {

        }

        public override void WriteData()
        {
            WriteBoolean(false);
        }
    }
}
