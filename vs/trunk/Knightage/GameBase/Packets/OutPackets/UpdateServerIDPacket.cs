using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;

namespace GameBase.Packets.OutPackets
{
    public class UpdateServerIDPacket : GamePacket
    {
        public UpdateServerIDPacket()
            : base()
        {
            Code = (int)BasePacketCode.UpdateServerID;
        }

        public byte ID { get; set; }

        public override void WriteData()
        {
            WriteUnsignedByte(ID);
        }
    }
}
