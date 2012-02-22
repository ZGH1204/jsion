using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using GameBase.Net;
using GameBase.Datas;

namespace CenterServer.Packets.OutPackets
{
    public class PlayerLoginSuccessPacket : GamePacket
    {
        public PlayerLoginSuccessPacket()
            : base()
        {
            Code = (int)BasePacketCode.Login;
            Code2 = (int)BasePacketCode.Gateway_Code;
        }

        public PlayerInfo PlayerInfo { get; set; }

        public override void WriteData()
        {
            WriteBoolean(true);

            WriteUnsignedInt(PlayerInfo.PlayerID);
            WriteUTF(PlayerInfo.Account);
            WriteUTF(PlayerInfo.NickName);
        }
    }

    public class PlayerLoginFailedPacket : GamePacket
    {
        public PlayerLoginFailedPacket()
            : base()
        {
            Code = (int)BasePacketCode.Login;
            Code2 = (int)BasePacketCode.Gateway_Code;
        }

        public override void WriteData()
        {
            WriteBoolean(false);
        }
    }
}
