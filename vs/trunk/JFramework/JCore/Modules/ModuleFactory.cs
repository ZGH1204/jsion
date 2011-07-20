using System;
using System.Reflection;
using System.IO;
using JUtils.Messages;

namespace JCore.Modules
{
    public class ModuleFactory
    {

        public static Module CreateModule(ModuleInfo moduleInfo)
        {
            Module module;

            Assembly assembly = Assembly.LoadFrom(Path.Combine(moduleInfo.CurDir, moduleInfo.File));

            try
            {
                Type type = assembly.GetType(moduleInfo.CLS);

                module = Activator.CreateInstance(type, moduleInfo) as Module;

                ModuleMonitor.RegisteModule(module);

                MsgMonitor.RegisteReceiver(module);
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return module;
        }
    }
}
