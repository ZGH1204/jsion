using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase;

namespace CenterServer.Packets.OutPackets
{
    public class ServerBusiesPacket : GamePacket
    {
        public ServerBusiesPacket()
            : base()
        {
            Code = (int)BasePacketCode.ServerBusies;
            Code2 = (int)BasePacketCode.Gateway_Code;
        }

        public uint ClientID { get; set; }

        public override void WriteData()
        {
            WriteUnsignedInt(ClientID);
        }
    }
}
