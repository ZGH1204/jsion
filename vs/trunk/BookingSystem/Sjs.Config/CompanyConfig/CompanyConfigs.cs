using System;
using System.Collections.Generic;
using System.Text;

namespace Sjs.Config.CompanyConfig
{
    /// <summary>
    /// 网站设置类
    /// </summary>
    public class CompanyConfigs
    {
        /// <summary>
        /// 锁对象
        /// </summary>
        private static object lockHelper = new object();

        /// <summary>
        /// 配置信息
        /// </summary>
        private static CompanyConfigInfo _configinfo;

        /// <summary>
        /// 定时检查是否更改网站配置信息(5分钟)
        /// </summary>
        private static System.Timers.Timer _companyConfigTimer = new System.Timers.Timer(300000);

        static CompanyConfigs()
        {
            ResetConfig();

            _companyConfigTimer.AutoReset = true;
            _companyConfigTimer.Elapsed += new System.Timers.ElapsedEventHandler(_companyConfigTimer_Elapsed);
            _companyConfigTimer.Enabled = true;
        }

        /// <summary>
        /// 定时器触发处理方法
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        static void _companyConfigTimer_Elapsed(object sender, System.Timers.ElapsedEventArgs e)
        {
            _configinfo = CompanyConfigFileManager.LoadConfig();
        }

        /// <summary>
        /// 重置配置信息
        /// </summary>
        public static void ResetConfig()
        {
            _configinfo = CompanyConfigFileManager.LoadRealConfig();
        }

        /// <summary>
        /// 配置信息访问点
        /// </summary>
        public static CompanyConfigInfo Config
        {
            get { return _configinfo; }
        }

        /// <summary>
        /// 更新并保存配置信息
        /// </summary>
        /// <param name="configinfo">新的配置信息</param>
        /// <returns>是否保存成功</returns>
        public static bool SaveConfig(CompanyConfigInfo configinfo)
        {
            CompanyConfigFileManager ccfm = new CompanyConfigFileManager();

            CompanyConfigFileManager.ConfigInfo = configinfo;

            return ccfm.SaveConfig();
        }
    }
}
