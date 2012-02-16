using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Command;

namespace GameServer.Commands.Startups
{
    [Cmd("ConnectCenterSrv", "连接中心服务器", "")]
    public class ConnectCenterServerCmd : ICommand
    {
        public bool Execute(string[] paramsList)
        {
            new CenterServerConnector(GameServerConfig.Configuration.CenterServer, GameServerConfig.Configuration.CenterPort);

            return true;
        }
    }
}
