using System;

namespace Sjs.Config
{
    /// <summary>
    /// 基本设置描述类, 加[Serializable]标记为可序列化
    /// </summary>
    [Serializable]
    public class BaseConfigInfo : IConfigInfo
    {

        #region 私有字段

        /// <summary>
        /// 数据库连接串-格式(中文为用户修改的内容)：
        /// Data Source=数据库服务器地址;
        /// User ID=您的数据库用户名;
        /// Password=您的数据库用户密码;
        /// Initial Catalog=数据库名称;
        /// Pooling=true
        /// 
        /// 默认值:Data Source=;User ID=sjs;Password=sjscan;Initial Catalog=;Pool=true
        /// </summary>
        private string _dbconnectionstring = "Data Source=;User ID=sjs;Password=sjscan;Initial Catalog=;Pool=true";

        /// <summary>
        /// 站点内的路径
        /// 默认值:/
        /// </summary>
        private string _sitepath = "/";

        /// <summary>
        /// 数据库类型
        /// 默认: string.Empty
        /// </summary>
        private string _dbtype = string.Empty;

        /// <summary>
        /// 创始人ID
        /// 默认值: 0
        /// </summary>
        private int _creatoruid = 0;

        /// <summary>
        /// 应用程序ID
        /// </summary>
        private int _appid = 0;

        #endregion

        #region 属性

        /// <summary>
        /// 数据库连接串
        /// 格式(中文为用户修改的内容)：
        ///    Data Source=数据库服务器地址;
        ///    User ID=您的数据库用户名;
        ///    Password=您的数据库用户密码;
        ///    Initial Catalog=数据库名称;Pooling=true
        ///    默认值:Data Source=;User ID=sjs;Password=gmyyvke;Initial Catalog=;Pool=true
        /// </summary>
        public string Dbconnectstring
        {
            get { return _dbconnectionstring; }
            set { _dbconnectionstring = value; }
        }

        /// <summary>
        /// 站点内的路径
        /// 默认值:/
        /// </summary>
        public string Sitepath
        {
            get { return _sitepath; }
            set { _sitepath = value; }
        }

        /// <summary>
        /// 数据库类型
        /// 默认: string.Empty
        /// </summary>
        public string Dbtype
        {
            get { return _dbtype; }
            set { _dbtype = value; }
        }

        /// <summary>
        /// 创始人ID
        /// 默认值:0
        /// </summary>
        public int Creatoruid
        {
            get { return _creatoruid; }
            set { _creatoruid = value; }
        }

        /// <summary>
        /// 应用程序ID
        /// </summary>
        public int Appid
        {
            get { return _appid; }
            set { _appid = value; }
        }

        #endregion

    }
}
