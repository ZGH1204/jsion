using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JsionFramework.Jsion.Attributes;
using JsionFramework.Jsion.Interfaces;
using GameServer.Managers;

namespace GameServer.Commands
{
    [Command("ClientCount", "查看玩家在线数量", "")]
    public class ClientCountCmd : ICommand
    {
        public bool Execute(string[] paramsList)
        {
            Console.WriteLine("Have {0} players online.", ClientMgr.ClientCount);

            return true;
        }
    }
}
