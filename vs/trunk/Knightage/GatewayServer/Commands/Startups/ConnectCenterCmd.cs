using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Command;

namespace GatewayServer.Commands.Startups
{
    [Cmd("ConnectCenter", "连接中心服务器", "")]
    public class ConnectCenterCmd : ICommand
    {
        public bool Execute(string[] paramsList)
        {
            GatewayGlobal.CenterServer.Connect(GatewayServerConfig.Configuration.CenterIP, GatewayServerConfig.Configuration.CenterPort);

            return true;
        }
    }
}
