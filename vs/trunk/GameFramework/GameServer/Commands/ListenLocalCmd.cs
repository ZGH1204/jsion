using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JsionFramework.Jsion.Attributes;
using JsionFramework.Jsion.Interfaces;
using GameServer.Managers;

namespace GameServer.Commands
{
    [Command("ListenLocal", "建立本地监听", "")]
    public class ListenLocalCmd : ICommand
    {
        public bool Execute(string[] paramsList)
        {
            if (GameServerMgr.Successed)
            {
                Console.WriteLine("系统正在运行中,不能重复建立本地监听!");
                return false;
            }
            bool rlt = GSServer.Instance.ListenLocal(GSConfigMgr.Configuration.Port);
            if (rlt) Console.WriteLine("本地监听建立完成!\r\n");
            return rlt;
        }
    }
}
