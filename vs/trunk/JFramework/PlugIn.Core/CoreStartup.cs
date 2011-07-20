
using System;
using JUtils;
using System.Reflection;
using log4net;
using System.Collections.Generic;
namespace PlugIn.Core
{
    public class CoreStartup
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        //public static List<object> StartupObj { get; private set; }

        public static void Startup(Action action = null)
        {
            ExportResources();

            InitEnvironment();

            PlugInTree.Load();

            log.Info("========================   以上为插件系统初始化信息   ========================");

            log.Info("============================   以下为运行时信息   ============================");

            //StartupObj = PlugInTree.BuildItems<object>(PlugInTree.Config.PathStartup, null);
            PlugInTree.BuildItems<object>(PlugInTree.Config.PathStartup, null);

            if (action != null) action();

            ServerUtil.WaitingCmd(PlugInTree.Config.AppName);
        }

        static void ExportResources()
        {
            log.Info("Exporting resources...");
            ResourceUtil.ExtractResourceSafe("LogConfig.xml", "LogConfig.xml", Assembly.GetAssembly(typeof(CoreStartup)));
        }

        static void InitEnvironment()
        {
            log.Info("Initialize environment...");

            ServerUtil.DisabledCloseBtn();

            AppUtil.AddApplicationExitHandler(ServerExitHandler);
        }

        static void ServerExitHandler()
        {
            log.Info("Server exit.");
        }
    }
}
