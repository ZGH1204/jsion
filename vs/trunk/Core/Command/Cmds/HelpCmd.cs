using System;
using System.Collections.Generic;
using System.Text;

namespace Command.Cmds
{
    [Cmd("Help", @"查看命令列表 与'/?'命令相同", "")]
    public class HelpCmd : ICommand
    {
        public bool Execute(string[] paramsList)
        {
            CommandMgr.Instance.DisplayCommandList();
            return true;
        }
    }
}
