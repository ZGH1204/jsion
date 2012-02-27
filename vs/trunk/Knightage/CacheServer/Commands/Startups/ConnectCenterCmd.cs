using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Command;
using GameBase.Managers;

namespace CacheServer.Commands.Startups
{
    [Cmd("ConnectCenter", "连接中心服务器", "")]
    public class ConnectCenterCmd : ICommand
    {
        public bool Execute(string[] paramsList)
        {
            if (ServerMgr.Instance.Contains(CacheServerConfig.Configuration.CenterIP, CacheServerConfig.Configuration.CenterPort))
            {
                return true;
            }

            CacheGlobal.CenterServer = new CenterServerConnector(CacheServerConfig.Configuration.CenterIP, CacheServerConfig.Configuration.CenterPort);

            return true;
        }
    }
}
