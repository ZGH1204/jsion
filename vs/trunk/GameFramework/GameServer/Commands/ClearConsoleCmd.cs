using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JsionFramework.Jsion.Interfaces;
using JsionFramework.Jsion.Attributes;

namespace GameServer.Commands
{
    [Command("Clear", "清除控制台文字", "")]
    public class ClearConsoleCmd : ICommand
    {
        public bool Execute(string[] paramsList)
        {
            Console.Clear();
            return true;
        }
    }
}
