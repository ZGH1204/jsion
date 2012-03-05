using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Command;
using GameBase.Managers;

namespace BattleServer.Commands.Startups
{
    [Cmd("ConnectCenter", "连接中心服务器", "")]
    public class ConnectCenterCmd : ICommand
    {
        public bool Execute(string[] paramsList)
        {
            BattleGlobal.CenterServer.Connect(BattleServerConfig.Configuration.CenterIP, BattleServerConfig.Configuration.CenterPort);

            return true;
        }
    }
}
