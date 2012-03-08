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
    [PacketHandler((int)BasePacketCode.Registe, "重新打包注册数据包")]
    public class RegisteHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            GatewayClient gc = client as GatewayClient;

            if (gc.Account.IsNullOrEmpty())
            {
                return 0;
            }

            RegisteServerPacket pkg = new RegisteServerPacket();

            pkg.ClientID = gc.ClientID;
            pkg.Account = gc.Account;
            pkg.NickName = packet.ReadUTF();

            GatewayGlobal.CenterServer.SendTCP(pkg);

            return 0;
        }
    }
}
