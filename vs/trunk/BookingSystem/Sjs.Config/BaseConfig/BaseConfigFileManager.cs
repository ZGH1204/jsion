using System;
using System.Text;
using System.Web;
using System.IO;
using Sjs.Common;

namespace Sjs.Config
{
    /// <summary>
    /// 文件配置管理基类
    /// </summary>
    class BaseConfigFileManager : DefaultConfigFileManager
    {
        private static BaseConfigInfo _configinfo;

        /// <summary>
        /// 锁对象
        /// </summary>
        private static object lockHelper = new object();

        /// <summary>
        /// 文件修改时间
        /// </summary>
        private static DateTime _fileoldchange;

        static BaseConfigFileManager()
        {
            _fileoldchange = System.IO.File.GetLastWriteTime(ConfigFilePath);

            _configinfo = (BaseConfigInfo)DefaultConfigFileManager.DeserializeInfo(ConfigFilePath, typeof(BaseConfigInfo));

            _configinfo.Dbconnectstring = Sjs.Common.DES.Decode(_configinfo.Dbconnectstring, "sjscanpvvvfb");
        }

        public new static IConfigInfo ConfigInfo
        {
            get { return _configinfo; }
            set { _configinfo = (BaseConfigInfo)value; }
        }

        /// <summary>
        /// 配置文件所在路径
        /// 
        /// 默认值:null
        /// </summary>
        public static string filename = null;

        /// <summary>
        /// 获取配置文件所在路径
        /// 
        /// 默认文件:/SJS.config
        /// </summary>
        public new static string ConfigFilePath
        {
            get 
            {
                if (filename==null)
                {
                    HttpContext context = HttpContext.Current;

                    if (context!=null)
                    {
                        filename = context.Server.MapPath("/SJS.config");
                    }
                    else
                    {
                        filename = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "SJS.config");
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
        /// 加载配置类(检查文件修改时间)
        /// </summary>
        /// <returns></returns>
        public static BaseConfigInfo LoadConfig()
        {
            ConfigInfo = DefaultConfigFileManager.LoadConfig(ref _fileoldchange, ConfigFilePath, ConfigInfo);

            BaseConfigInfo rtnConfigInfo = ConfigInfo as BaseConfigInfo;

            if (rtnConfigInfo == null)
            {
                return null;
            }

            // 解密
            rtnConfigInfo.Dbconnectstring = Sjs.Common.DES.Decode(rtnConfigInfo.Dbconnectstring, "sjscanpvvvfb");

            return rtnConfigInfo;       //如果转换失败则返回null
        }

        /// <summary>
        /// 加载真正有效的配置类(不检查文件修改时间，强制更新配置信息)
        /// </summary>
        /// <returns></returns>
        public static BaseConfigInfo LoadRealConfig()
        {
            ConfigInfo = DefaultConfigFileManager.LoadConfig(ref _fileoldchange, ConfigFilePath, ConfigInfo, false);

            BaseConfigInfo rtnConfigInfo = ConfigInfo as BaseConfigInfo;

            if (rtnConfigInfo == null)
            {
                return null;
            }

            // 解密
            rtnConfigInfo.Dbconnectstring = Sjs.Common.DES.Decode(rtnConfigInfo.Dbconnectstring, "sjscanpvvvfb");

            return rtnConfigInfo;       //如果转换失败则返回null
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
