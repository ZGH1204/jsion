using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using GameBase.Packets.OutPackets;
using JUtils;
using GameBase.Net;

namespace GatewayServer
{
    public class CenterServerConnector : ServerConnector
    {
        public CenterServerConnector(string ip, int port)
            : base(ip, port)
        { }

        public override string ServerName
        {
            get
            {
                return "中心服务器";
            }
        }

        protected override void OnConnected(bool successed)
        {
            base.OnConnected(successed);

            if (successed)
            {
                ValidateServerTypePacket pkg = new ValidateServerTypePacket();

                pkg.ServerType = ServerType.GatewayServer;
                pkg.IP = JUtil.GetLocalIP();
                pkg.Port = GatewayServerConfig.Configuration.Port;

                SendTCP(pkg);
            }
        }

        protected override void ReceivePacket(GamePacket packet)
        {
            if (packet.Code2 == 0)
            {
                if (GatewayGlobal.PlayerLoginMgr[packet.PlayerID] != null)
                {
                    GatewayGlobal.PlayerLoginMgr[packet.PlayerID].SendTcp(packet);
                }
            }
            else
            {
                base.ReceivePacket(packet);
            }
        }
    }
}
