using System;

namespace Sjs.Config
{
    /// <summary>
    /// 基本设置类
    /// </summary>
    public class BaseConfigs
    {
        /// <summary>
        /// 锁对象
        /// </summary>
        private static object lockHelper = new object();

        /// <summary>
        /// 定时器
        /// </summary>
        private static System.Timers.Timer _baseConfigTimer = new System.Timers.Timer(15000);

        private static BaseConfigInfo _configinfo;

        /// <summary>
        /// 静态构造函数初始化相应实例和定时器
        /// </summary>
        static BaseConfigs()
        {
            _configinfo = BaseConfigFileManager.LoadConfig();

            _baseConfigTimer.AutoReset = true;
            _baseConfigTimer.Enabled = true;
            _baseConfigTimer.Elapsed += new System.Timers.ElapsedEventHandler(Timer_Elapsed);
        }

        private static void Timer_Elapsed(object sender, System.Timers.ElapsedEventArgs e)
        {
            ResetConfig();
        }

        /// <summary>
        /// 重设配置类实例
        /// </summary>
        public static void ResetConfig()
        {
            _configinfo = BaseConfigFileManager.LoadRealConfig();
        }

        public static BaseConfigInfo GetBaseConfig()
        {
            return _configinfo;
        }

        /// <summary>
        /// 返回数据库连接串
        /// </summary>
        public static string GetDBConnectString
        {
            get { return GetBaseConfig().Dbconnectstring; }
        }


        /// <summary>
        /// 得到论坛创建人ID
        /// </summary>
        public static int GetCreatorUid
        {
            get
            {
                return GetBaseConfig().Creatoruid;
            }
        }

        /// <summary>
        /// 返回网站路径
        /// </summary>
        public static string GetSitePath
        {
            get
            {
                return GetBaseConfig().Sitepath;
            }
        }

        /// <summary>
        /// 返回数据库类型
        /// </summary>
        public static string GetDbType
        {
            get
            {
                return GetBaseConfig().Dbtype;
            }
        }

        /// <summary>
        /// 返回应用程序ID
        /// </summary>
        public static int GetAppid
        {
            get
            {
                return GetBaseConfig().Appid;
            }
        }

        /// <summary>
        /// 保存配置
        /// </summary>
        /// <param name="baseconfiginfo"></param>
        /// <returns></returns>
        public static bool SaveConfig(BaseConfigInfo baseconfiginfo)
        {
            BaseConfigFileManager bcfm = new BaseConfigFileManager();

            // 加密
            baseconfiginfo.Dbconnectstring = Sjs.Common.DES.Encode(baseconfiginfo.Dbconnectstring, "sjscanpvvvfb");

            BaseConfigFileManager.ConfigInfo = baseconfiginfo;

            return bcfm.SaveConfig();
        }
    }
}
