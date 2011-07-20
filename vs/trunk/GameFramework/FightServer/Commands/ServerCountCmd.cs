using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JsionFramework.Jsion.Attributes;
using JsionFramework.Jsion.Interfaces;
using FightServer.Managers;
using JsionFramework.Jsion.Managers;

namespace FightServer.Commands
{
    [Command("ServerCount", "查看当前游戏服务器数量", "ServerCount [-ip]")]
    [CommandParameter("-ip", "列出所有游戏服务IP地址和端口号")]
    public class ServerCountCmd : ICommand
    {
        public bool Execute(string[] paramsList)
        {
            Console.WriteLine("    当前有 {0} 个游戏服务器正在运行!", GameServerMgr.GetClientCount());

            if (paramsList.Length == 0) return true;

            string param = CommandMgr.GetParam("-ip", paramsList);

            if (!string.IsNullOrEmpty(param))
            {
                ServerClient[] list = GameServerMgr.GetAllClient();

                for (int i = 0; i < list.Length; i++)
                {
                    CommandMgr.WriteLine(8, (i + 1).ToString() + ")", 4, list[i].Socket.RemoteEndPoint);
                }
            }

            return true;
        }
    }
}
