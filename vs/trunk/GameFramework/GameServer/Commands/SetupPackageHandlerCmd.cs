using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JsionFramework.Jsion.Attributes;
using JsionFramework.Jsion.Interfaces;
using GameServer.Packages;
using System.Reflection;
using GameServer.Managers;

namespace GameServer.Commands
{
    [Command("SetupPackageHandler", "初始化协议包处理对象列表", "")]
    public class SetupPackageHandlerCmd : ICommand
    {
        public bool Execute(string[] paramsList)
        {
            if (GameServerMgr.Successed)
            {
                Console.WriteLine("系统正在运行中,不能重复初始化协议包处理对象列表!");
                return false;
            }
            PackageHandlers.SearchPackageHandler(Assembly.GetAssembly(typeof(GSServer)));
            CenterPackageHandlers.SearchPackageHandler(Assembly.GetAssembly(typeof(GSServer)));
            Console.WriteLine("协议包处理对象列表初始化!\r\n");
            return true;
        }
    }
}
