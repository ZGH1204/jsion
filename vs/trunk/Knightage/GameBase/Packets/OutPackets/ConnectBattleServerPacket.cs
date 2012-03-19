using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;

namespace GameBase.Packets.OutPackets
{
    public class ConnectBattleServerPacket : GatewayPacket
    {
        public ConnectBattleServerPacket()
            : base(BasePacketCode.ConnectBattleServer)
        { }

        public int ID { get; set; }

        public string IP { get; set; }

        public int Port { get; set; }

        public override void WriteData()
        {
            WriteInt(ID);

            WriteUTF(IP);

            WriteInt(Port);
        }
    }
}
