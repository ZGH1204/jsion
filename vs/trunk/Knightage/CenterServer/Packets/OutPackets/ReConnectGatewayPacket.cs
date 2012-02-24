using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase;

namespace CenterServer.Packets.OutPackets
{
    public class ReConnectGatewayPacket : GamePacket
    {
        public ReConnectGatewayPacket()
            : base()
        {
            Code = (int)BasePacketCode.ReConnectGateway;
            Code2 = (int)BasePacketCode.Gateway_Code;
        }

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
