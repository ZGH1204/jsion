using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using GameBase.Net;

namespace GameServer
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

        protected override void ReceivePacket(GamePacket packet)
        {
            //TODO: 转发给玩家客户端
        }
    }
}
