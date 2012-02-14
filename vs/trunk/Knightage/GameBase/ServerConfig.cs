using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AppConfig;
using System.Reflection;
using System.IO;

namespace GameBase
{
    public class ServerConfig : AppConfigAbstract
    {
        public static ServerConfig Configuration { get; protected set; }

        static ServerConfig()
        {
            Configuration = new ServerConfig();
            Configuration.Load();
        }

        [AppConfig("ServerName", "服务器名称", "未配置")]
        public string ServerName;

        [AppConfig("Port", "监听端口", 8000)]
        public int Port;

        [AppConfig("MaxClients", "最大连接数", 5000)]
        public int MaxClients;

        [AppConfig("BuffSize", "字节流大小", 2048)]
        public int BuffSize;

        [AppConfig("BuffPoolSize", "字节流缓冲池大小", 15000)]
        public int BuffPoolSize;

        [AppConfig("TemplateFile", "模板文件", "templates.xml")]
        public string TemplateFile;

        [AppConfig("StartupCmds", "启动依次执行的命令列表", "")]
        public string StartupCmds;

        public void Load()
        {
            if (Assembly.GetEntryAssembly() == null)
            {
                RootDirectory = new FileInfo(Assembly.GetAssembly(typeof(ServerConfig)).Location).DirectoryName;
            }
            else
            {
                RootDirectory = new FileInfo(Assembly.GetEntryAssembly().Location).DirectoryName;
            }

            Load(typeof(ServerConfig));
        }

        public string RootDirectory { get; set; }


    }
}
