using System.IO;
using JCore.Modules;

namespace JCore
{
    internal class ModuleStartup
    {
        public static void Startup()
        {
            //加载基本配置
            Config.Load();

            //加载模块信息列表
            LoadMod();

            //安装并启动模块
            Install();
        }

        /// <summary>
        /// 扫描模块目录，加载模块信息列表。
        /// </summary>
        private static void LoadMod()
        {
            string[] list = Directory.GetFiles(Path.Combine(Config.config.ApplicationRootDir, Config.config.ModuleRootDir), "*.mod");

            foreach (string item in list)
            {
                ModuleInfo moduleInfo = (ModuleInfo)JUtils.SerializationUtil.Load(typeof(ModuleInfo), item);

                moduleInfo.CurDir = Path.GetDirectoryName(item);

                ModuleInfoMonitor.RegisteModuleInfo(moduleInfo);
            }
        }

        /// <summary>
        /// 安装并启动初始模块(模块信息中Startup属性为true的模块)
        /// </summary>
        private static void Install()
        {
            foreach (ModuleInfo moduleInfo in ModuleInfoMonitor.StartupModuleInfoList)
            {
                ModuleFactory.CreateModule(moduleInfo);
            }
        }
    }
}
