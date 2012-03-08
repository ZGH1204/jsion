using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase;

namespace GatewayServer.Packets.OutServerPackets
{
    public class RegisteServerPacket : CenterPacket
    {
        public RegisteServerPacket()
            : base(BasePacketCode.ValidateRegiste)
        {

        }

        public uint ClientID { get; set; }

        public string Account { get; set; }

        public string NickName { get; set; }

        public override void WriteData()
        {
            WriteUnsignedInt(ClientID);

            WriteUTF(Account);

            WriteUTF(NickName);
        }
    }
}
