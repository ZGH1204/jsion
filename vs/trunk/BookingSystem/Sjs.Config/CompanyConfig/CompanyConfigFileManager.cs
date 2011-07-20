using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.IO;
using Sjs.Common;

namespace Sjs.Config.CompanyConfig
{
    class CompanyConfigFileManager : DefaultConfigFileManager
    {
        /// <summary>
        /// 配置信息
        /// </summary>
        private static CompanyConfigInfo _configinfo;

        /// <summary>
        /// 锁对象
        /// </summary>
        private static object lockHelper = new object();

        /// <summary>
        /// 文件修改时间
        /// </summary>
        private static DateTime _fileoldchange;

        /// <summary>
        /// 配置文件所在路径
        /// 
        /// 默认值:null
        /// </summary>
        public static string filename = null;

        /// <summary>
        /// 配置文件所在路径(绝对路径)
        /// </summary>
        public new static string ConfigFilePath
        {
            get
            {
                if (filename == null)
                {
                    HttpContext context = HttpContext.Current;
                    if (context != null)
                    {
                        filename = context.Server.MapPath("/Company.config");
                    }
                    else
                    {
                        filename = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Company.config");
                    }

                    if (!File.Exists(filename))
                    {
                        throw new SJSException("发生错误: 网站根目录下没有正确的SJS.config文件");
                    }
                }

                return filename;
            }
        }

        /// <summary>
        /// 配置信息
        /// </summary>
        public new static IConfigInfo ConfigInfo
        {
            get { return _configinfo; }
            set { _configinfo = (CompanyConfigInfo)value; }
        }

        /// <summary>
        /// 构造函数
        /// </summary>
        static CompanyConfigFileManager()
        {
            _fileoldchange = System.IO.File.GetLastWriteTime(ConfigFilePath);
        }

        /// <summary>
        /// 加载配置文件信息(检查文件修改时间)
        /// </summary>
        /// <returns></returns>
        public static CompanyConfigInfo LoadConfig()
        {
            ConfigInfo = DefaultConfigFileManager.LoadConfig(ref _fileoldchange, ConfigFilePath, ConfigInfo);

            return _configinfo;
        }

        /// <summary>
        /// 加载配置文件信息(不检查文件修改时间，强制更新配置信息)
        /// </summary>
        /// <returns></returns>
        public static CompanyConfigInfo LoadRealConfig()
        {
            ConfigInfo = DefaultConfigFileManager.LoadConfig(ref _fileoldchange, ConfigFilePath, ConfigInfo, false);

            return _configinfo;
        }

        /// <summary>
        /// 保存配置
        /// </summary>
        /// <returns></returns>
        public override bool SaveConfig()
        {
            return base.SaveConfig(ConfigFilePath, ConfigInfo);
        }
    }
}
