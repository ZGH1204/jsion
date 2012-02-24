using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;

namespace GameBase.Packets.OutPackets
{
    public class ValidateServerTypePacket : CenterPacket
    {
        public ValidateServerTypePacket()
            : base(BasePacketCode.ValidateServer)
        {
        }

        public ServerType ServerType { get; set; }

        public string IP { get; set; }

        public int Port { get; set; }

        public override void WriteData()
        {
            WriteUnsignedByte((byte)ServerType);
            WriteUTF(IP);
            WriteInt(Port);
        }
    }
}
