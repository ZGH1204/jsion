using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JsionFramework.Jsion.Attributes;
using JsionFramework.Jsion.Interfaces;
using Jsion;
using GameServer.Managers;

namespace GameServer.Commands
{
    [Command("AllocBuffer", "初始化字节流缓冲池", "")]
    public class AllocBufferCmd : ICommand
    {
        public bool Execute(string[] paramsList)
        {
            if (GameServerMgr.Successed)
            {
                Console.WriteLine("系统正在运行中,不能重复初始化节流缓冲池!");
                return false;
            }
            BufferMgr.Setup(GSConfigMgr.Configuration.ClientsCountMax * 3);
            Console.WriteLine("字节流缓冲池初始化完成!\r\n");
            return true;
        }
    }
}
