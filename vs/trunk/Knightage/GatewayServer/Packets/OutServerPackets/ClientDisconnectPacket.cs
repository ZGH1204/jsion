using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase;

namespace GatewayServer.Packets.OutServerPackets
{
    public class ClientDisconnectPacket : GamePacket
    {
        public ClientDisconnectPacket(uint playerID)
            : base(BasePacketCode.ClientDisconnect, BasePacketCode.None_Code)
        {
            PlayerID = playerID;
        }

        public uint ClientID { get; set; }

        public override void WriteData()
        {
            WriteUnsignedInt(ClientID);
        }
    }
}
