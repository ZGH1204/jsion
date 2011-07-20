using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using log4net;
using System.Reflection;
using PlugIn.Core.DefaultDoozers;
using System.Collections;

namespace PlugIn.Core
{
    public class PlugInTree
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        static List<string> plugInFiles = new List<string>();

        static PlugInTreeNode RootNode = new PlugInTreeNode();

        public static PlugInConfig Config { get; private set; }

        public static List<PlugIn> plugInsList = new List<PlugIn>();

        public static Dictionary<string, IDoozer> Doozers { get; private set; }


        public static void Load()
        {
            log.Info("Load and build plug-in tree...");

            if (Doozers == null)
            {
                Doozers = new Dictionary<string, IDoozer>();
                Doozers.Add("Class", new ClassDoozer());
            }

            //加载插件系统配置
            Config = new PlugInConfig();
            Config.LoadAppConfig();

            //安装插件
            InstallPlugIn(disabledList);

            //扫描插件目录获取插件配置文件列表
            SearchPlugInFiles();

            //解析插件配置文件列表所有配置文件到插件列表
            ParsePlugInFiles();
        }

        static List<string> disabledList = new List<string>();

        private static void InstallPlugIn(List<string> disabled)
        {
            if (!Directory.Exists(Config.InstallDir)) return;

            log.Info("InstallPlugIns started");

            if (!Directory.Exists(Config.UserPlugInDir))
            {
                Directory.CreateDirectory(Config.UserPlugInDir);
            }

            string removeFile = Path.Combine(Config.InstallDir, Config.RemovesFile);
            bool allOk = true;
            List<string> notRemove = new List<string>();
            if (File.Exists(removeFile))
            {
                using (StreamReader r = new StreamReader(removeFile))
                {
                    string dirName;
                    while ((dirName = r.ReadLine()) != null)
                    {
                        dirName = dirName.Trim();

                        if (dirName.Length == 0)
                        {
                            continue;
                        }

                        string targetDir = Path.Combine(Config.UserPlugInDir, dirName);

                        if (!UninstallPlugIn(disabled, dirName, targetDir))
                        {
                            notRemove.Add(dirName);
                            allOk = false;
                        }
                    }
                }

                if (notRemove.Count == 0 )
                {
                    log.Info("Deleting remove.txt");
                    File.Delete(removeFile);
                }
                else
                {
                    log.Info("Rewriting remove.txt");
                    using (StreamWriter w = new StreamWriter(removeFile))
                    {
                        notRemove.ForEach(w.WriteLine);
                    }
                }
            }

            foreach (string sourceDir in Directory.GetDirectories(Config.InstallDir))
            {
                string plugInName = Path.GetFileName(sourceDir);

                string targetDir = Path.Combine(Config.UserPlugInDir, plugInName);

                if (notRemove.Contains(plugInName))
                {
                    log.InfoFormat("Skipping installation of {0} because deinstallation failed.", plugInName);
                    continue;
                }

                if (UninstallPlugIn(disabled, plugInName, targetDir))
                {
                    log.InfoFormat("Installing {0} ...", plugInName);
                    Directory.Move(sourceDir, targetDir);
                }
                else
                {
                    allOk = false;
                }
            }

            if (allOk)
            {
                try
                {
                    Directory.Delete(Config.InstallDir, false);
                }
                catch (Exception ex)
                {
                    log.Warn("Error removing install dir", ex);
                }
            }

            log.Info("InstallPlugIns finished.");
        }

        private static bool UninstallPlugIn(List<string> disabled, string dirName, string targetDir)
        {
            if (Directory.Exists(targetDir))
            {
                log.Info("Moving " + dirName + "...");

                if (!Directory.Exists(Config.BackupDir)) Directory.CreateDirectory(Config.BackupDir);

                try
                {
                    Directory.Move(targetDir, Path.Combine(Config.BackupDir, dirName));
                }
                catch (Exception ex)
                {
                    disabled.Add(dirName);
                    log.ErrorFormat("Error moving {0} directory:\n{1}\nThe PlugIn will be moved on the next start and is disabled for now.", dirName, ex.Message);
                    return false;
                }
            }

            return true;
        }

        private static void SearchPlugInFiles()
        {
            try
            {
                string dir = Path.Combine(Config.ApplicationRootDir, Config.UserPlugInDir);

                if (Directory.Exists(dir) == false) Directory.CreateDirectory(dir);

                string[] list = Directory.GetFiles(dir, "*." + Config.PlugInFileExt, SearchOption.AllDirectories);

                plugInFiles.AddRange(list);
            }
            catch (Exception ex)
            {
                log.Error("Error search plug-in file.", ex);
            }
        }

        private static void ParsePlugInFiles()
        {
            PlugIn plugIn;
            foreach (string file in plugInFiles)
            {
                try
                {
                    plugIn = PlugIn.Load(file);
                }
                catch (Exception ex)
                {
                    log.ErrorFormat("Error loading PlugIn {0} :\n{1}", file, ex.Message);
                    plugIn = new PlugIn();

                    plugIn.PlugInFile = file;
                    plugIn.CustomErrorMsg = ex.Message;
                }

                if (plugIn.CustomErrorMsg.IsNotNullOrEmpty())
                {
                    plugInsList.Add(plugIn);
                    continue;
                }

                plugIn.Enabled = true;

                if (disabledList != null && disabledList.Count > 0)
                {
                    foreach (string dir in disabledList)
                    {
                        if (plugIn.PlugInDir.IndexOf(dir) >= 0)
                        {
                            plugIn.Enabled = false;
                            break;
                        }
                    }
                }

                if (plugIn.Enabled)
                {
                    plugInsList.Add(plugIn);

                    foreach (ExtensionPath path in plugIn.Paths.Values)
                    {
                        PlugInTreeNode treePath = RootNode.CreatePath(path.Name);
                        treePath.AddCodons(path.Codons);
                    }

                    foreach (Runtime runtime in plugIn.Runtimes)
                    {
                        foreach (LazyDoozer doozer in runtime.DefinedDoozers)
                        {
                            if (Doozers.ContainsKey(doozer.Name))
                            {
                                throw new Exception("Duplicate doozer: " + doozer.Name);
                            }

                            Doozers.Add(doozer.Name, doozer);
                        }
                    }
                }
            }
        }






        public static bool ExistsTreeNode(string path)
        {
            return RootNode.ExistsTreeNode(path);
        }

        public static PlugInTreeNode GetTreeNode(string path)
        {
            return RootNode.GetTreeNode(path);
        }

        public static PlugInTreeNode GetTreeNode(string path, bool throwOnNotFound)
        {
            return RootNode.GetTreeNode(path, throwOnNotFound);
        }





        public static object BuildItem(string path, object caller)
        {
            int pos = path.LastIndexOf('/');
            string parent = path.Substring(0, pos);
            string child = path.Substring(pos + 1);
            PlugInTreeNode node = RootNode.GetTreeNode(parent);
            return node.BuildChildItem(child, caller, new ArrayList(BuildItems<object>(path, caller, false)));
        }

        public static List<T> BuildItems<T>(string path, object caller)
        {
            return BuildItems<T>(path, caller, true);
        }

        public static List<T> BuildItems<T>(string path, object caller, bool throwOnNotFound)
        {
            PlugInTreeNode node = RootNode.GetTreeNode(path, throwOnNotFound);

            if (node == null)
            {
                return new List<T>();
            }
            else
            {
                return node.BuildChildItems<T>(caller);
            }
        }
    }
}
