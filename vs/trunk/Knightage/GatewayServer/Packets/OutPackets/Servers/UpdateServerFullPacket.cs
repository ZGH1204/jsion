using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase;

namespace GatewayServer.Packets.OutPackets.Servers
{
    public class UpdateServerFullPacket : GamePacket
    {
        public UpdateServerFullPacket()
            : base()
        {
            Code = (int)BasePacketCode.UpdateServerFull;
            Code2 = (int)BasePacketCode.Center_Code;
        }

        public int GatewayID { get; set; }

        public int ClientID { get; set; }

        public override void WriteData()
        {
            WriteInt(GatewayID);

            WriteInt(ClientID);
        }
    }
}
