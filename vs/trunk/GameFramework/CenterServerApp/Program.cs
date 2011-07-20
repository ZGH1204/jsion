using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Jsion.Utils;
using System.Reflection;
using CenterServer.Managers;
using Jsion;
using CenterServer.Packages;
using CenterServer;
using JsionFramework.Jsion.Managers;

namespace CenterServerApp
{
    class Program
    {
        static void Main(string[] args)
        {
            ResourceUtil.ExtractResource("LogConfig.xml", "LogConfig.xml", Assembly.GetAssembly(typeof(Program)));
            //ResourceUtil.ExtractResourceSafe("LogConfig.xml", "LogConfig.xml", Assembly.GetAssembly(typeof(Program)));

            //ResourceUtil.ExtractResource("server.config", "server.config", Assembly.GetAssembly(typeof(Program)));
            //GSConfigMgr.LoadGameServerConfig("server.config");

            CenterServerMgr.DisabledCloseBtn();

            CommandMgr.Instance.SearchCommand(Assembly.GetAssembly(typeof(CSServer)));

            Console.WriteLine("指令系统初始化完成!!\r\n");

            if (!CommandMgr.Instance.ExecuteCommand("LoadCenterConfig"))
            {
                CenterServerMgr.PressKeyExit();
                return;
            }

            if (!CommandMgr.Instance.ExecuteCommand("AllocBuffer"))
            {
                CenterServerMgr.PressKeyExit();
                return;
            }

            if (!CommandMgr.Instance.ExecuteCommand("SetupPackageHandler"))
            {
                CenterServerMgr.PressKeyExit();
                return;
            }

            if (!CommandMgr.Instance.ExecuteCommand("ListenLocal"))
            {
                CenterServerMgr.PressKeyExit();
                return;
            }

            CenterServerMgr.Success();

            Console.WriteLine("中心服务器启动成功!!!\r\n");

            CenterServerMgr.WaitingInputCmd("CenterServer");
        }
    }
}
