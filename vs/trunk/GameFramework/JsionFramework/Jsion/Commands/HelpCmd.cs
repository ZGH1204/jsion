using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JsionFramework.Jsion.Attributes;
using JsionFramework.Jsion.Interfaces;
using JsionFramework.Jsion.Managers;

namespace JsionFramework.Jsion.Commands
{
    [Command("Help", @"查看命令列表 与'/?'命令相同", "")]
    public class HelpCmd : ICommand
    {
        public bool Execute(string[] paramsList)
        {
            CommandMgr.Instance.DisplayCommandList();
            return true;
        }
    }
}
