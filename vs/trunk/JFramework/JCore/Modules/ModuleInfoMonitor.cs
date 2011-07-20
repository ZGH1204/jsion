using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JCore.Modules
{
    public class ModuleInfoMonitor
    {
        static IList<ModuleInfo> startupModuleInfoList = new List<ModuleInfo>();
        static Dictionary<string, ModuleInfo> moduleInfoList = new Dictionary<string, ModuleInfo>();

        public static IList<ModuleInfo> StartupModuleInfoList { get { return startupModuleInfoList; } }

        public static void RegisteModuleInfo(ModuleInfo moduleInfo)
        {
            if (moduleInfo == null || moduleInfo.File.IsNullOrEmpty() || moduleInfo.ID.IsNullOrEmpty()) return;

            if (moduleInfoList.ContainsKey(moduleInfo.ID))
            {
                throw new Exception(moduleInfo.ID + "模块已存在，请更改其他模块ID。");
            }

            moduleInfoList[moduleInfo.ID] = moduleInfo;
            if (moduleInfo.Startup) startupModuleInfoList.Add(moduleInfo);
        }

        public static ModuleInfo RemoveModuleInfo(string id)
        {
            if (moduleInfoList.ContainsKey(id))
            {
                ModuleInfo info = moduleInfoList[id];

                moduleInfoList.Remove(id);

                return info;
            }

            return null;
        }

        public static void RemoveModuleInfo(ModuleInfo moduleInfo)
        {
            if (moduleInfo == null)
            {
                throw new ArgumentNullException("moduleInfo");
            }

            RemoveModuleInfo(moduleInfo.ID);
        }

        public static ModuleInfo GetModuleInfo(string id)
        {
            return moduleInfoList[id];
        }

        public static bool ContainsModuleInfo(string id)
        {
            return moduleInfoList.ContainsKey(id);
        }
    }
}
