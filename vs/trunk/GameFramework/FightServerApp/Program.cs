using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Jsion.Utils;
using System.Reflection;
using FightServer;
using FightServer.Managers;
using JsionFramework.Jsion.Managers;

namespace FightServerApp
{
    class Program
    {
        static void Main(string[] args)
        {
            ResourceUtil.ExtractResource("LogConfig.xml", "LogConfig.xml", Assembly.GetAssembly(typeof(Program)));
            //ResourceUtil.ExtractResourceSafe("LogConfig.xml", "LogConfig.xml", Assembly.GetAssembly(typeof(Program)));

            //ResourceUtil.ExtractResource("server.config", "server.config", Assembly.GetAssembly(typeof(Program)));
            //GSConfigMgr.LoadGameServerConfig("server.config");


            FightServerMgr.DisabledCloseBtn();

            CommandMgr.Instance.SearchCommand(Assembly.GetAssembly(typeof(FSServer)));

            Console.WriteLine("指令系统初始化完成!!\r\n");

            if (!CommandMgr.Instance.ExecuteCommand("LoadFightConfig"))
            {
                FightServerMgr.PressKeyExit();
                return;
            }

            if (!CommandMgr.Instance.ExecuteCommand("AllocBuffer"))
            {
                FightServerMgr.PressKeyExit();
                return;
            }

            if (!CommandMgr.Instance.ExecuteCommand("SetupPackageHandler"))
            {
                FightServerMgr.PressKeyExit();
                return;
            }

            if (!CommandMgr.Instance.ExecuteCommand("ListenLocal"))
            {
                FightServerMgr.PressKeyExit();
                return;
            }

            FightServerMgr.Success();

            Console.WriteLine("战斗服务器启动成功!!!\r\n");

            FightServerMgr.WaitingInputCmd("FightServer");
        }
    }
}
