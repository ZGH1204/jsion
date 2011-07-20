using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Xml;
using JUtils;
using log4net;
using System.Reflection;

namespace PlugIn.Core
{
    public class PlugIn
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        internal PlugIn() { }

        public string PlugInDir { get; private set; }

        public string PlugInFile { get; internal set; }

        public Properties Properties { get; private set; }

        public List<Runtime> Runtimes { get; private set; }

        public Dictionary<string, ExtensionPath> Paths { get; private set; }

        public PlugInManifest Manifest { get; private set; }

        public string Name { get { return Properties["name"]; } }

        public string Author { get { return Properties["author"]; } }

        public string Description { get { return Properties["description"]; } }

        public bool Enabled { get; set; }

        public string CustomErrorMsg { get; set; }



        public void LoadRuntimeAssemblies()
        {
            LoadDependencies();

            LoadRuntimes();
        }

        volatile bool runtimesLoaded;
        private void LoadRuntimes()
        {
            if (runtimesLoaded == false)
            {
                runtimesLoaded = true;

                foreach (Runtime runtime in Runtimes)
                {
                    runtime.Load();
                }
            }
        }

        volatile bool dependenciesLoaded;
        private void LoadDependencies()
        {
            if (dependenciesLoaded == false)
            {
                AssemblyLocator.Initialize();

                foreach (PlugInReference r in Manifest.Dependencies)
                {
                    if (r.RequirePreload)
                    {
                        bool found = false;

                        foreach (PlugIn plugIn in PlugInTree.plugInsList)
                        {
                            if (plugIn.Manifest.Identities.ContainsKey(r.Name))
                            {
                                found = true;
                                plugIn.LoadRuntimeAssemblies();
                            }
                        }

                        if (!found)
                        {
                            throw new Exception("Can't load run-time dependency form " + r.ToString());
                        }
                    }
                }

                dependenciesLoaded = true;
            }
        }





        public IDoozer CreateDoozer(string className)
        {
            return (IDoozer)CreateObject(className);
        }

        public object CreateObject(string className)
        {
            Type t = FindType(className);

            if (t != null) return Activator.CreateInstance(t);
            else return null;
        }

        public Type FindType(string className)
        {
            LoadRuntimeAssemblies();

            foreach (Runtime runtime in Runtimes)
            {
                Type t = runtime.FindType(className);

                if (t != null) return t;
            }

            return null;
        }











        public static PlugIn Load(string fileName)
        {
            try
            {
                using (TextReader textReader = File.OpenText(fileName))
                {
                    PlugIn plugIn = new PlugIn();

                    plugIn.PlugInFile = fileName;
                    plugIn.PlugInDir = Path.GetDirectoryName(fileName);

                    Load(textReader, plugIn);

                    return plugIn;
                }
            }
            catch (Exception ex)
            {
                log.Error("Error parse plug-in file.", ex);
                throw ex;
            }
        }

        static void Load(TextReader textReader, PlugIn plugIn)
        {
            using (XmlTextReader reader = new XmlTextReader(textReader))
            {
                while (reader.Read())
                {
                    if (reader.IsStartElement())
                    {
                        switch (reader.LocalName)
                        {
                            case PlugInConst.RootElement:
                                SetupPlugIn(reader, plugIn);
                                break;
                            default:
                                throw new Exception("Unknow plug-in file.");
                        }
                    }
                }
            }
        }

        static void SetupPlugIn(XmlReader reader, PlugIn plugIn)
        {
            plugIn.Properties = Properties.ReadFromAttributes(reader);

            plugIn.Runtimes = new List<Runtime>();

            plugIn.Paths = new Dictionary<string, ExtensionPath>();

            plugIn.Manifest = new PlugInManifest();

            while (reader.Read())
            {
                if (reader.NodeType == XmlNodeType.Element && reader.IsStartElement())
                {
                    switch (reader.LocalName)
                    {
                        case PlugInConst.Runtime:
                            Runtime.ReadRuntime(reader, plugIn);
                            break;
                        case PlugInConst.Path:
                            ExtensionPath.ReadPath(reader, plugIn);
                            break;
                        case PlugInConst.Manifest:
                            plugIn.Manifest.ReadManifest(reader, plugIn);
                            break;
                        default:
                            break;
                    }
                }
            }
        }

        public override string ToString()
        {
            return "[PlugIn: " + Name + "]";
        }
    }
}
