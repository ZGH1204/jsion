using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase;

namespace CenterServer.Packets.OutPackets
{
    public class RegistePlayerPacket : GatewayPacket
    {
        public RegistePlayerPacket()
            : base(BasePacketCode.Registe)
        {

        }

        public uint ClientID { get; set; }

        public override void WriteData()
        {
            WriteUnsignedInt(ClientID);
        }
    }
}
