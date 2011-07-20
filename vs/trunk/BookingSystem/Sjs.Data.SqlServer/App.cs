using System;
using System.Collections.Generic;
using System.Text;

using System.Data;
using SJSCAN.Entity;
using System.Data.Common;

namespace Sjs.Data.SqlServer
{
    public partial class DataProvider : Sjs.Data.IDataProvider
    {
        public int AddApp(App app)
        {
            string cmdText = "INSERT INTO App(isinstall)VALUES(@isinstall);SELECT @@identity";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@isinstall", (DbType)SqlDbType.Bit, 0, app.Isinstall)/**/
                                          };
            
            string s = DbHelper.ExecuteScalar(CommandType.Text, cmdText, cmdParameters).ToString();
            int i = (string.IsNullOrEmpty(s) ? 0 : int.Parse(s));
            return i;
        }

        public int DelApp(int id)
        {
            string cmdText = "DELETE FROM App WHERE id=@id";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, id)/**/
                                          };

            return DbHelper.ExecuteNonQuery(CommandType.Text, cmdText, cmdParameters);
        }

        public int UpdateApp(App app)
        {
            string cmdText = "UPDATE App SET isinstall=@isinstall WHERE id=@id";

            DbParameter[] cmdParameters = {
                                                
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, app.Id)/**/,
                                                DbHelper.MakeInParam("@isinstall", (DbType)SqlDbType.Bit, 0, app.Isinstall)/**/
                                          };

            return DbHelper.ExecuteNonQuery(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetApp(int id)
        {
            string cmdText = "SELECT * FROM App WHERE id=@id ";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, id)/**/
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetApp()
        {
            string cmdText = "SELECT * FROM App";

            DbParameter[] cmdParameters = {
                                                
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetApp(int pageSize, int currentPage)
        {
            if (pageSize <= 0)
            {
                pageSize = 10;

            }
            if (currentPage <= 0)
            {
                currentPage = 1;
            }

            int pagetop = (currentPage - 1) * pageSize;

            DbParameter[] cmdParameters = {  };

            string cmdText = "";

            if (currentPage == 1)
            {
                cmdText = string.Format("select top {0} * from App order by id desc", pageSize.ToString());
            }
            else
            {
                cmdText = string.Format("select top {0} * from App where id < (select min(id) from (select top {1} id from App order by id desc) as tblTmp) order by id desc", pageSize.ToString(), pagetop.ToString());
            }
            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

    }
}
