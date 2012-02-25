using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;
using GatewayServer.Packets.OutPackets.Servers;

namespace GatewayServer.Packets.Handlers
{
    [PacketHandler((int)BasePacketCode.Login, "玩家发送的登陆包")]
    public class LoginHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            string account = packet.ReadUTF();

            ValidateLoginPacket pkg = new ValidateLoginPacket();

            pkg.ClientID = ((GatewayClient)client).ClientID;
            pkg.Account = account;

            GatewayGlobal.CenterServer.SendTCP(pkg);

            return 0;
        }
    }
}
