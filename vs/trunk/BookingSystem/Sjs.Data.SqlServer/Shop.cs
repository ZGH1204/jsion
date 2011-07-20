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
        public int AddShop(Shop shop)
        {
            string cmdText = "INSERT INTO Shop(shopname,phone)VALUES(@shop,@phone);SELECT @@identity";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@shop", (DbType)SqlDbType.NChar, 20, shop.Shopname)/**/,
                                                DbHelper.MakeInParam("@phone", (DbType)SqlDbType.NChar, 20, shop.Phone)/**/
                                          };
            
            string s = DbHelper.ExecuteScalar(CommandType.Text, cmdText, cmdParameters).ToString();
            int i = (string.IsNullOrEmpty(s) ? 0 : int.Parse(s));
            return i;
        }

        public int AddShop(Shop shop, DbTransaction trans)
        {
            string cmdText = "INSERT INTO Shop(shopname,phone)VALUES(@shop,@phone);SELECT @@identity";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@shop", (DbType)SqlDbType.NChar, 20, shop.Shopname)/**/,
                                                DbHelper.MakeInParam("@phone", (DbType)SqlDbType.NChar, 20, shop.Phone)/**/
                                          };

            string s = DbHelper.ExecuteScalar(trans, CommandType.Text, cmdText, cmdParameters).ToString();
            int i = (string.IsNullOrEmpty(s) ? 0 : int.Parse(s));
            return i;
        }

        public int DelShop(int id)
        {
            string cmdText = "DELETE FROM Shop WHERE id=@id";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, id)/**/
                                          };

            return DbHelper.ExecuteNonQuery(CommandType.Text, cmdText, cmdParameters);
        }

        public int DelShop(int id, DbTransaction trans)
        {
            string cmdText = "DELETE FROM Shop WHERE id=@id";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, id)/**/
                                          };

            return DbHelper.ExecuteNonQuery(trans, CommandType.Text, cmdText, cmdParameters);
        }

        public int UpdateShop(Shop shop)
        {
            string cmdText = "UPDATE Shop SET shopname=@shop, phone=@phone WHERE id=@id";

            DbParameter[] cmdParameters = {
                                                
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, shop.Id)/**/,
                                                DbHelper.MakeInParam("@shop", (DbType)SqlDbType.NChar, 20, shop.Shopname)/**/,
                                                DbHelper.MakeInParam("@phone", (DbType)SqlDbType.NChar, 20, shop.Phone)/**/
                                          };

            return DbHelper.ExecuteNonQuery(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetShop(int id)
        {
            string cmdText = "SELECT * FROM Shop WHERE id=@id ";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, id)/**/
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetShop()
        {
            string cmdText = "SELECT * FROM Shop";

            DbParameter[] cmdParameters = {
                                                
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetShop(int pageSize, int currentPage)
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
                cmdText = string.Format("select top {0} * from Shop order by id desc", pageSize.ToString());
            }
            else
            {
                cmdText = string.Format("select top {0} * from Shop where id < (select min(id) from (select top {1} id from Shop order by id desc) as tblTmp) order by id desc", pageSize.ToString(), pagetop.ToString());
            }
            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

    }
}
