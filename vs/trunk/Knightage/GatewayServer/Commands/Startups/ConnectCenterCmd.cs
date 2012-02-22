using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Command;
using GameBase.Managers;

namespace GatewayServer.Commands.Startups
{
    [Cmd("ConnectCenter", "连接中心服务器", "")]
    public class ConnectCenterCmd : ICommand
    {
        public bool Execute(string[] paramsList)
        {
            if (ServerMgr.Instance.Contains(GatewayServerConfig.Configuration.CenterIP, GatewayServerConfig.Configuration.CenterPort))
            {
                return true;
            }

            GatewayGlobal.CenterServer = new CenterServerConnector(GatewayServerConfig.Configuration.CenterIP, GatewayServerConfig.Configuration.CenterPort);

            return true;
        }
    }
}
