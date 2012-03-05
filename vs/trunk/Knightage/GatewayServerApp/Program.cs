using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using log4net;
using System.Reflection;
using GatewayServer;
using JUtils;
using Command;
using System.Threading;

namespace GatewayServerApp
{
    class Program
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        static void Main(string[] args)
        {
            Console.Title = GatewayServerConfig.Configuration.ServerName;

            ResourceUtil.ExtractResourceSafe("LogConfig.xml", "LogConfig.xml", Assembly.GetAssembly(typeof(ResourceUtil)));

            //ServerUtil.DisabledCloseBtn();

            CommandMgr.Instance.SearchCommand(Assembly.GetAssembly(typeof(AssemblyHelper)));

            log.Info("指令系统初始化成功!!!");

            string[] list = GatewayServerConfig.Configuration.StartupCmds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);


            foreach (string cmd in list)
            {
                if (CommandMgr.Instance.ExecuteCommand(cmd) == false)
                {
                    ServerUtil.PressKeyExit();
                    return;
                }
            }

            ServerUtil.ReceiveCmdEvent += new ServerUtil.CmdHandler(ServerUtil_ReceiveCmdEvent);

            Thread.Sleep(3000);

            Console.WriteLine("{0}启动成功!!!\r\n", GatewayServerConfig.Configuration.ServerName);

            ServerUtil.WaitingCmd(GatewayServerConfig.Configuration.ServerName);
        }

        static void ServerUtil_ReceiveCmdEvent(string cmd)
        {
            try
            {
                CommandMgr.Instance.ExecuteCommand(cmd);
            }
            catch (Exception ex)
            {
                log.Error("ExecuteCommand Error!", ex);
            }
        }
    }
}
