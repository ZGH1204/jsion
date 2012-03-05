using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase;

namespace CenterServer.Packets.OutPackets
{
    public class ReConnectGatewayPacket : GatewayPacket
    {
        public ReConnectGatewayPacket()
            : base(BasePacketCode.ReConnectGateway)
        { }

        public uint ClientID { get; set; }

        public string IP { get; set; }

        public int Port { get; set; }

        public override void WriteData()
        {
            WriteUnsignedInt(ClientID);
            WriteUTF(IP);
            WriteInt(Port);
        }
    }
}
