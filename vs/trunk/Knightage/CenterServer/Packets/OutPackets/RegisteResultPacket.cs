using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;

namespace CenterServer.Packets.OutPackets
{
    public class RegisteResultPacket : GatewayPacket
    {
        public RegisteResultPacket()
            : base(GameBase.BasePacketCode.Registe)
        {

        }

        public uint ClientID { get; set; }

        public override void WriteData()
        {
            WriteUnsignedInt(ClientID);
        }
    }
}
