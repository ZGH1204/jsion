using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Command;
using Net;

namespace CacheServer.Commands.Startups
{
    [Cmd("AllocBuffer", "初始化字节流缓冲池", "")]
    public class AllocBufferCmd : ICommand
    {
        public bool Execute(string[] paramsList)
        {
            BufferMgr.Setup(CacheServerConfig.Configuration.BuffSize, CacheServerConfig.Configuration.BuffPoolSize);

            return true;
        }
    }
}
