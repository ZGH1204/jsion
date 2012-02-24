using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;

namespace GameBase.Packets.OutPackets
{
    public class ConnectLogicServerPacket : GamePacket
    {
        public ConnectLogicServerPacket()
            : base()
        {
            Code = (int)BasePacketCode.ConnectLogicServer;
        }

        public uint ID { get; set; }

        public string IP { get; set; }

        public int Port { get; set; }

        public override void WriteData()
        {
            WriteUnsignedInt(ID);

            WriteUTF(IP);

            WriteInt(Port);
        }
    }
}
