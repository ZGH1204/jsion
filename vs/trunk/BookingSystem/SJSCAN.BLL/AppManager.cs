using System;
using System.Collections.Generic;
using System.Text;

using SJSCAN.Entity;
using Sjs.Data;
using System.Data;

namespace SJSCAN.BLL
{
    public partial class AppManager
    {
        /// <summary>
        /// 添加方法
        /// </summary>
        public static int AddApp(App app)
        {
            return DatabaseProvider.GetInstance().AddApp(app);
        }

        /// <summary>
        /// 删除方法
        /// </summary>
        public static int DelApp(int id)
        {
            return DatabaseProvider.GetInstance().DelApp(id);
        }

        /// <summary>
        /// 修改方法
        /// </summary>
        public static int UpdateApp(App app)
        {
            return DatabaseProvider.GetInstance().UpdateApp(app);
        }

        public static App GetApp(int id)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetApp(id);

            App model = null;

            if(reader.Read())
            {
                model = GetApp(reader);
            }

            reader.Close();
            return model;
        }

        public static IList<App> GetApp(  )
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetApp( );

            IList<App> list = new List<App>();

            while(reader.Read())
            {
                App model = GetApp(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static IList<App> GetApp(int pageSize, int  currentPage)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetApp(pageSize, currentPage);

            IList<App> list = new List<App>();

            while(reader.Read())
            {
                App model = GetApp(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static App GetApp(IDataReader reader)
        {
            App model = new App();

            model.Id = (reader["Id"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Id"]));
            model.Isinstall = (reader["Isinstall"] is DBNull ? Convert.ToBoolean("false") : Convert.ToBoolean(reader["Isinstall"]));


            return model;
        }

    }
}
