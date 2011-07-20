using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;

namespace JUtils
{
    public static class AssemblyLocator
    {
        static Dictionary<string, Assembly> assemblies = new Dictionary<string, Assembly>();
        static bool initialized;

        public static void Initialize()
        {
            lock (assemblies)
            {
                if (initialized) return;

                initialized = true;

                AppDomain.CurrentDomain.AssemblyResolve += new ResolveEventHandler(CurrentDomain_AssemblyResolve);
                AppDomain.CurrentDomain.AssemblyLoad += new AssemblyLoadEventHandler(CurrentDomain_AssemblyLoad);
            }
        }

        static Assembly CurrentDomain_AssemblyResolve(object sender, ResolveEventArgs args)
        {
            lock (assemblies)
            {
                Assembly assembly = null;
                assemblies.TryGetValue(args.Name, out assembly);
                return assembly;
            }
        }

        static void CurrentDomain_AssemblyLoad(object sender, AssemblyLoadEventArgs args)
        {
            Assembly assembly = args.LoadedAssembly;
            lock (assemblies)
            {
                assemblies[assembly.FullName] = assembly;
            }
        }
    }
}
