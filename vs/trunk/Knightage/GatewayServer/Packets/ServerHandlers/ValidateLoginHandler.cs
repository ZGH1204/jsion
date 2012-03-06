using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;
using GameBase.Datas;

namespace GatewayServer.Packets.ServerHandlers
{
    [PacketHandler((int)BasePacketCode.ValidateLogin, "中心服务器验证后返回")]
    public class ValidateLoginHandler : IServerPacketHandler
    {
        public int HandlePacket(ServerConnector connector, GamePacket packet)
        {
            uint clientID = packet.ReadUnsignedInt();

            GatewayClient client = GatewayGlobal.Clients[clientID];

            LoginInfo info = new LoginInfo();

            info.PlayerID = packet.PlayerID;

            GatewayPlayer player = new GatewayPlayer(info, client);
            
            GatewayGlobal.Players.Add(packet.PlayerID, player);

            packet.Code2 = (int)BasePacketCode.None_Code;

            player.Client.LogicServer.SendTCP(packet);

            return 0;
        }
    }
}
