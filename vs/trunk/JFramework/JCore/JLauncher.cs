using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JUtils;
using System.Reflection;
using System.Threading;
using JCore.Modules;

namespace JCore
{
    public class JLauncher
    {
        public JLauncher()
        {

        }

        public void Startup()
        {
            //禁用关闭按钮
            ServerUtil.DisabledCloseBtn();

            //SerializationUtil.Save(new ModuleInfo { ID="Module1", File="Command.dll", CLS="CommandModule", Startup=false}, "module.mod");

            //导出日志配置文件
            ResourceUtil.ExtractResourceSafe("LogConfig.xml", "LogConfig.xml", Assembly.GetAssembly(typeof(JLauncher)));

            //启动模块环境
            ModuleStartup.Startup();

            //注册应用程序关闭系统钩子
            AppUtil.AddApplicationExitHandler(ServerExitHandler);

            //挂起线程
            ServerUtil.WaitingCmd("JTest");
        }

        /// <summary>
        /// 窗口关闭系统级钩子
        /// </summary>
        private void ServerExitHandler()
        {
            Console.WriteLine("关闭应用程序");
        }
    }
}
