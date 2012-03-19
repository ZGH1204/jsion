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

        public int ClientID { get; set; }

        public string IP { get; set; }

        public int Port { get; set; }

        public override void WriteData()
        {
            WriteInt(ClientID);
            WriteUTF(IP);
            WriteInt(Port);
        }
    }
}
