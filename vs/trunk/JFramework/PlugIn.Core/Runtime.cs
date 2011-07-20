using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Reflection;
using PlugIn.Core.DefaultDoozers;
using System.IO;
using log4net;

namespace PlugIn.Core
{
    public class Runtime
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        bool isAssemblyLoaded = false;
        readonly object lockObj = new object(); // used to protect mutable parts of runtime

        public string AssemblyFile { get; private set; }

        public string AssemblyDir { get; private set; }

        Assembly loadedAssembly = null;
        public Assembly LoadedAssembly
        {
            get
            {
                if (loadedAssembly == null) Load();

                return loadedAssembly;
            }
        }

        public IList<LazyDoozer> DefinedDoozers { get; private set; }

        public Runtime(string assemblyFile, string assemblyDir)
        {
            // TODO: Complete member initialization
            AssemblyFile = assemblyFile;
            AssemblyDir = assemblyDir;
            DefinedDoozers = new List<LazyDoozer>();
        }





        public void Load()
        {
            lock (lockObj)
            {
                if (isAssemblyLoaded == false)
                {
                    isAssemblyLoaded = true;

                    try
                    {
                        if (AssemblyFile[0] == ':')
                        {
                            loadedAssembly = LoadAssembly(AssemblyFile);
                        }
                        else
                        {
                            loadedAssembly = LoadAssemblyFile(Path.Combine(AssemblyDir, AssemblyFile));
                        }
                    }
                    catch (Exception ex)
                    {
                        log.Error("Error reflection run-time : " + AssemblyFile, ex);
                    }
                }
            }
        }

        protected virtual Assembly LoadAssembly(string assemblyString)
        {
            return Assembly.Load(assemblyString);
        }

        protected virtual Assembly LoadAssemblyFile(string assemblyFile)
        {
            return Assembly.LoadFrom(assemblyFile);
        }






        public Type FindType(string className)
        {
            //Load();

            if (LoadedAssembly == null) return null;

            return LoadedAssembly.GetType(className);
        }







        #region 静态方法

        public static void ReadRuntime(XmlReader reader, PlugIn plugIn)
        {
            while (reader.Read())
            {
                switch (reader.NodeType)
                {
                    case XmlNodeType.Element:
                        switch (reader.LocalName)
                        {
                            case PlugInConst.RuntimeImport:
                                plugIn.Runtimes.Add(Read(plugIn, reader));
                                break;
                            default:
                                break;
                        }
                        break;
                    case XmlNodeType.EndElement:
                        if (reader.LocalName == PlugInConst.Runtime) return;
                        break;
                    default:
                        break;
                }
            }
        }

        private static Runtime Read(PlugIn plugIn, XmlReader reader)
        {
            if (reader.AttributeCount != 1)
            {
                throw new Exception(PlugInConst.RuntimeImport + " node requires only one attribute.");
            }

            Runtime runtime = new Runtime(reader.GetAttribute(0), plugIn.PlugInDir);

            if (!reader.IsEmptyElement)
            {
                while (reader.Read())
                {
                    switch (reader.NodeType)
                    {
                        case XmlNodeType.Element:
                            string nodeName = reader.LocalName;
                            Properties properties = Properties.ReadFromAttributes(reader);

                            switch (nodeName)
                            {
                                case PlugInConst.RuntimeImportDoozer:
                                    if (reader.HasAttributes == false)
                                    {
                                        throw new Exception("Doozer node must be have attributes!");
                                    }
                                    runtime.DefinedDoozers.Add(new LazyDoozer(plugIn, properties));
                                    break;
                                default:
                                    throw new Exception("Unknown node in Import section:" + nodeName);
                            }
                            break;
                        case XmlNodeType.EndElement:
                            if (reader.LocalName == PlugInConst.RuntimeImport)
                            {
                                runtime.DefinedDoozers = (runtime.DefinedDoozers as List<LazyDoozer>).AsReadOnly();
                                return runtime;
                            }
                            break;
                    }
                }
            }

            runtime.DefinedDoozers = (runtime.DefinedDoozers as List<LazyDoozer>).AsReadOnly();

            return runtime;
        }

        #endregion
    }
}
