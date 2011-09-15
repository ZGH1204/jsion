using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Command.Cmds
{
    [Cmd("Clear", "清除控制台文字信息", "")]
    public class ClearCmd : ICommand
    {
        public bool Execute(string[] paramsList)
        {
            Console.Clear();

            return true;
        }
    }
}
