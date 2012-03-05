using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JUtils;
using GameBase.Packets.OutPackets;

namespace GameBase
{
    public class CenterServerConnector : ServerConnector
    {
        public ServerType ServerType { get; protected set; }

        public int ListenPort { get; protected set; }

        public CenterServerConnector(ServerType type, int listenPort)
            : base()
        {
            ServerType = type;
            ListenPort = listenPort;
        }

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

                pkg.ServerType = ServerType;
                pkg.IP = JUtil.GetLocalIP();
                pkg.Port = ListenPort;

                SendTCP(pkg);
            }
        }
    }
}
