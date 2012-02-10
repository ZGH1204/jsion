using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Command;
using System.Reflection;
using JUtils;
using GameBase;

namespace CoreConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            TemplateMgr<GeneralTemplate> tm = new TemplateMgr<GeneralTemplate>();

            tm.Load("Templates.xml", "/root/ArrayOfGeneralTemplate");

            CommandMgr.Instance.SearchCommand(Assembly.GetAssembly(typeof(Program)));

            ServerUtil.ReceiveCmdEvent += new ServerUtil.CmdHandler(ServerUtil_ReceiveCmdEvent);

            ServerUtil.WaitingCmd("Test");
        }

        static void ServerUtil_ReceiveCmdEvent(string cmd)
        {
            try
            {
                CommandMgr.Instance.ExecuteCommand(cmd);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
        }
    }
}
