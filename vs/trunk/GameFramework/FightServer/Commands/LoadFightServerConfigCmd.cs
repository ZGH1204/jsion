using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JsionFramework.Jsion.Attributes;
using JsionFramework.Jsion.Interfaces;
using FightServer.Managers;

namespace FightServer.Commands
{
    [Command("LoadFightConfig", "加载中心服务器配置文件", "")]
    public class LoadFightServerConfigCmd : ICommand
    {
        public bool Execute(string[] paramsList)
        {
            if (FightServerMgr.Successed)
            {
                Console.WriteLine("系统正在运行中,不能重复加载中心服务器配置文件!\r\n");
                return false;
            }
            FSConfigMgr.CreateConfig();
            return true;
        }
    }
}
