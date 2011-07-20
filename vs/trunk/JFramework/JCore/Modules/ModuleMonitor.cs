using System;
using System.Collections.Generic;

namespace JCore.Modules
{
    public class ModuleMonitor
    {
        static Dictionary<string, Module> moduleList = new Dictionary<string, Module>();

        public static void RegisteModule(Module module)
        {
            if (moduleList.ContainsKey(module.ID))
            {
                throw new Exception(module.ID + "模块已存在!");
            }

            moduleList[module.ID] = module;
        }

        public static Module RemoveModule(string id)
        {
            if (moduleList.ContainsKey(id))
            {
                Module module = moduleList[id];

                moduleList.Remove(id);

                return module;
            }

            return null;
        }

        public static void RemoveModule(Module module)
        {
            if (module == null || module.ID.IsNullOrEmpty()) return;
            RemoveModule(module.ID);
        }
    }
}
