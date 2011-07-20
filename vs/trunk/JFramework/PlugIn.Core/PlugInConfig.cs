using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JUtils;
using JUtils.Attributes;

namespace PlugIn.Core
{
    public class PlugInConfig : AppConfigAbstract
    {
        public string ApplicationRootDir;

        [AppConfig("AppName", "应用程序名称", "")]
        public string AppName;

        [AppConfig("UserPlugInDir", "用户插件目录", "plugins")]
        public string UserPlugInDir;

        [AppConfig("InstallDir", "要安装插件的存放目录", "installs")]
        public string InstallDir;

        [AppConfig("BackupDir", "卸载插件的备份目录", "backups")]
        public string BackupDir;

        [AppConfig("RemovesFile", "要删除插件列表存放的文件，位于InstallDir目录下。", "removes.txt")]
        public string RemovesFile;

        [AppConfig("PlugInFileExt", "插件配置文件扩展名", "plugin")]
        public string PlugInFileExt;

        [AppConfig("PathStartup", "系统启动的入口扩展点", "/App/Startup")]
        public string PathStartup;

        public void LoadAppConfig()
        {
            ApplicationRootDir = Environment.CurrentDirectory;

            Load(typeof(PlugInConfig));
        }
    }
}
