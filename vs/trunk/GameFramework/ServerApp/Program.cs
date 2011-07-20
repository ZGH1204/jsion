using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Jsion.Utils;
using System.Reflection;
using Jsion.NetWork.Sockets;
using System.Net.Sockets;
using Jsion.NetWork.Packet;
using GameServer;
using GameServer.Managers;
using GameServer.Packages;
using Jsion;
using JsionFramework.Jsion.Managers;

namespace ServerApp
{
    class Program
    {
        static void Main(string[] args)
        {
            ResourceUtil.ExtractResource("LogConfig.xml", "LogConfig.xml", Assembly.GetAssembly(typeof(Program)));
            //ResourceUtil.ExtractResourceSafe("LogConfig.xml", "LogConfig.xml", Assembly.GetAssembly(typeof(Program)));

            //ResourceUtil.ExtractResource("server.config", "server.config", Assembly.GetAssembly(typeof(Program)));
            //ResourceUtil.ExtractResourceSafe("server.config", "server.config", Assembly.GetAssembly(typeof(Program)));
            //GSConfigMgr.LoadGameServerConfig("server.config");

            GameServerMgr.DisabledCloseBtn();

            CommandMgr.Instance.SearchCommand(Assembly.GetAssembly(typeof(GSServer)));

            Console.WriteLine("指令系统初始化成功!!!\r\n");

            if (!CommandMgr.Instance.ExecuteCommand("LoadGameConfig"))
            {
                GameServerMgr.PressKeyExit();
                return;
            }

            if (!CommandMgr.Instance.ExecuteCommand("AllocBuffer"))
            {
                GameServerMgr.PressKeyExit();
                return;
            }

            if (!CommandMgr.Instance.ExecuteCommand("SetupPackageHandler"))
            {
                GameServerMgr.PressKeyExit();
                return;
            }

            if (!CommandMgr.Instance.ExecuteCommand("ListenLocal"))
            {
                GameServerMgr.PressKeyExit();
                return;
            }

            GameServerMgr.ConnectCenterServer();

            FightServerMgr.ConnectFightServers();

            GameServerMgr.Success();

            Console.WriteLine("游戏服务器启动成功!!!\r\n");

            GameServerMgr.WaitingInputCmd("GameServer");
        }
    }
}
