using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;

namespace GameBase.Packets.OutPackets
{
    public class ConnectCacheServerPacket : GatewayPacket
    {
        public ConnectCacheServerPacket()
            : base(BasePacketCode.ConnectCacheServer)
        { }

        public string IP { get; set; }

        public int Port { get; set; }

        public override void WriteData()
        {
            WriteUTF(IP);

            WriteInt(Port);
        }
    }
}
