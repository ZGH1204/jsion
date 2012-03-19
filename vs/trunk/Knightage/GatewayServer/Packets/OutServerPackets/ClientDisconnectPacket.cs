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
        public ClientDisconnectPacket(int playerID)
            : base(BasePacketCode.ClientDisconnect, BasePacketCode.None_Code)
        {
            PlayerID = playerID;
        }

        public int ClientID { get; set; }

        public override void WriteData()
        {
            WriteInt(ClientID);
        }
    }
}
