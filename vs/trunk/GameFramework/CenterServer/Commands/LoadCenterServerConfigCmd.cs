using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JsionFramework.Jsion.Attributes;
using JsionFramework.Jsion.Interfaces;
using CenterServer.Managers;

namespace CenterServer.Commands
{
    [Command("LoadCenterConfig", "加载中心服务器配置文件", "")]
    public class LoadCenterServerConfigCmd : ICommand
    {
        public bool Execute(string[] paramsList)
        {
            if (CenterServerMgr.Successed)
            {
                Console.WriteLine("系统正在运行中,不能重复加载中心服务器配置文件!\r\n");
                return false;
            }
            CSConfigMgr.CreateConfig();
            return true;
        }
    }
}
