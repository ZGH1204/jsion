using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JsionFramework.Jsion.Attributes;
using JsionFramework.Jsion.Interfaces;
using FightServer.Managers;

namespace FightServer.Commands
{
    [Command("ListenLocal", "建立本地监听", "")]
    public class ListenLocalCmd : ICommand
    {
        public bool Execute(string[] paramsList)
        {
            if (FightServerMgr.Successed)
            {
                Console.WriteLine("系统正在运行中,不能重复建立本地监听!");
                return false;
            }
            bool rlt = FSServer.Instance.ListenLocal(FSConfigMgr.Configuration.Port);
            if(rlt) Console.WriteLine("本地监听建立完成!\r\n");
            return rlt;
        }
    }
}
