using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Command;

namespace BattleServer.Commands.Startups
{
    [Cmd("StartBattleThread", "", "")]
    public class StartBattleThreadCmd : ICommand
    {
        public bool Execute(string[] paramsList)
        {
            BattleMgr.Start();

            return true;
        }
    }
}
