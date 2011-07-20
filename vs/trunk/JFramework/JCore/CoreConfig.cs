using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JUtils;
using JUtils.Attributes;

namespace JCore
{
    public class CoreConfig : AppConfigAbstract
    {
        /// <summary>
        /// 应用程序要目录
        /// </summary>
        public string ApplicationRootDir;

        /// <summary>
        /// 模块所在根目录
        /// </summary>
        [AppConfig("ModuleRootDir", "模块所在根目录(相对于应用程序要目录)", "modules")]
        public string ModuleRootDir;





        public void Refresh()
        {
            ApplicationRootDir = Environment.CurrentDirectory;
            Load(typeof(CoreConfig));
        }
    }
}
