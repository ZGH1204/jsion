using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Command;
using log4net;
using System.Reflection;
using GameBase;

namespace GatewayServer.Commands.Startups
{
    [Cmd("Listen", "监听端口", "仅启动时使用")]
    public class ListenPortCmd : ICommand
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public bool Execute(string[] paramsList)
        {
            try
            {
                GatewaySrv.Server.Listen(GatewayServerConfig.Configuration.Port);
            }
            catch (Exception ex)
            {
                log.Error(string.Format("监听端口失败! Port:{0}", GatewayServerConfig.Configuration.Port), ex);
            }
            return true;
        }
    }
}
