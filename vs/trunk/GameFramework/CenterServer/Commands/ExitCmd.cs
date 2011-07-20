using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JsionFramework.Jsion.Attributes;
using JsionFramework.Jsion.Interfaces;

namespace CenterServer.Commands
{
    [Command("Exit", "退出应用程序", "")]
    public class ExitCmd : ICommand
    {
        public bool Execute(string[] paramsList)
        {
            Environment.Exit(0);
            return true;
        }
    }
}
