using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Command;
using GameBase.Managers;

namespace GameServer.Commands.Startups
{
    [Cmd("ConnectCenterSrv", "连接中心服务器", "")]
    public class ConnectCenterServerCmd : ICommand
    {
        public bool Execute(string[] paramsList)
        {
            if (ServerMgr.Instance.Contains(GameServerConfig.Configuration.CenterIP, GameServerConfig.Configuration.CenterPort))
            {
                return true;
            }

            new CenterServerConnector(GameServerConfig.Configuration.CenterIP, GameServerConfig.Configuration.CenterPort);

            return true;
        }
    }
}
