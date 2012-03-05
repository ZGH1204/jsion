using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Command;
using Net;

namespace GameServer.Commands.Startups
{
    [Cmd("AllocBuffer", "初始化字节流缓冲池", "")]
    public class AllocBufferCmd : ICommand
    {
        public bool Execute(string[] paramsList)
        {
            BufferMgr.Setup(GameServerConfig.Configuration.BuffSize, GameServerConfig.Configuration.BuffPoolSize);

            return true;
        }
    }
}
