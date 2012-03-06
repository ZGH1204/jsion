using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;
using GameBase.ServerConfigs;
using CenterServer.Packets.OutPackets;
using System.Reflection;
using log4net;

namespace CenterServer.Packets.Handlers
{
    [PacketHandler((int)BasePacketCode.ChangeGateway, "查找并通知客户端重定向到其他网关")]
    public class ChangeGatewayHandler : IPacketHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            uint gatewayID = packet.ReadUnsignedInt();
            uint clientID = packet.ReadUnsignedInt();

            ConnectOtherGatewayServer(client, gatewayID, clientID);

            return 0;
        }

        public static void ConnectOtherGatewayServer(ClientBase client, uint gatewayID, uint clientID)
        {
            GatewayInfo info = CenterGlobal.GetFreeGateway(gatewayID);

            if (info != null)
            {
                ReConnectGatewayPacket pkg = new ReConnectGatewayPacket();

                pkg.ClientID = clientID;
                pkg.IP = info.IP;
                pkg.Port = info.Port;

                client.SendTcp(pkg);
            }
            else
            {
                //TODO: 通知客户端服务器繁忙

                log.Warn("所有网关服务器满载 请增开新的网关服务器");

                ServerBusiesPacket pkg = new ServerBusiesPacket();

                pkg.ClientID = clientID;

                client.SendTcp(pkg);
            }
        }
    }
}
