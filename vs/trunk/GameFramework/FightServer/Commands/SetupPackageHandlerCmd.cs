using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JsionFramework.Jsion.Attributes;
using JsionFramework.Jsion.Interfaces;
using System.Reflection;
using FightServer.Managers;
using FightServer.Packages;
using FightServer;

namespace FightServer.Commands
{
    [Command("SetupPackageHandler", "初始化协议包处理对象列表", "")]
    public class SetupPackageHandlerCmd : ICommand
    {
        public bool Execute(string[] paramsList)
        {
            if (FightServerMgr.Successed)
            {
                Console.WriteLine("系统正在运行中,不能重复初始化协议包处理对象列表!");
                return false;
            }
            PackageHandlers.SearchPackageHandler(Assembly.GetAssembly(typeof(FSServer)));
            Console.WriteLine("协议包处理对象列表初始化!\r\n");
            return true;
        }
    }
}
