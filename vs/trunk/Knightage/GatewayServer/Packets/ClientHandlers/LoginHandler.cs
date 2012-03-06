using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;
using GatewayServer.Packets.OutServerPackets;

namespace GatewayServer.Packets.ClientHandlers
{
    [PacketHandler((int)BasePacketCode.Login, "分配逻辑服务器并重新打包登陆数据包")]
    public class LoginHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            GatewayClient gc = client as GatewayClient;

            gc.LogicServer = GatewayGlobal.GetFreeLogicServer(gc);

            if (gc.LogicServer == null)
            {
                return 0;
            }

            string account = packet.ReadUTF();

            ValidateLoginPacket pkg = new ValidateLoginPacket();

            pkg.ClientID = gc.ClientID;
            pkg.Account = account;

            GatewayGlobal.CenterServer.SendTCP(pkg);

            return 0;
        }
    }
}
