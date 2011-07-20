using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JsionFramework.Jsion.Interfaces;
using JsionFramework.Jsion.Attributes;
using GameServer.Managers;

namespace GameServer.Commands
{
    [Command("LoadGameConfig", "加载游戏服务器配置文件", "")]
    public class LoadGameServerConfigCmd : ICommand
    {
        public bool Execute(string[] paramsList)
        {
            if (GameServerMgr.Successed)
            {
                Console.WriteLine("系统正在运行中,不能重复加载游戏服务器配置文件!");
                return false;
            }
            GSConfigMgr.CreateConfig();
            Console.WriteLine("游戏服务器配置文件加载完成!\r\n");
            return true;
        }
    }
}
