using System;
using System.Collections.Generic;
using System.Text;
using Sjs.Config;

namespace Sjs.Data
{
    /// <summary>
    /// 提供全局一个业务处理类实例
    /// 设计模式,单例模式,全局共用一个实例
    /// </summary>
    public class DatabaseProvider
    {
        private DatabaseProvider()
        {}

        private static IDataProvider _instance = null;

        private static object lockHelper = new object();

        static DatabaseProvider()
        {
            GetProvider();
        }

        private static void GetProvider()
        {
            try
            {
                _instance = (IDataProvider)Activator.CreateInstance(Type.GetType(string.Format("Sjs.Data.{0}.DataProvider,Sjs.Data.{0}", BaseConfigs.GetDbType), false, true));
            }
            catch
            {
                throw new Exception("请检查SJS.config中Dbtype节点数据库类型是否正确，例如：SqlServer、Access、MySql");
            }
        }

        public static IDataProvider GetInstance()
        {
            if (_instance==null)
            {
                lock (lockHelper)
                {
                    if (_instance==null)
                    {
                        GetProvider();
                    }
                }
            }

            return _instance;
        }

        public static void ResetDbProvider()
        {
            _instance = null;
        }
    }
}
