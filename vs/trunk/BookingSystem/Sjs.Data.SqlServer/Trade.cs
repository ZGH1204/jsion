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
        public int AddTrade(Trade trade)
        {
            string cmdText = "INSERT INTO Trade(shopid,tradename,tradevalue)VALUES(@shopid,@tradename,@tradevalue);SELECT @@identity";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@shopid", (DbType)SqlDbType.Int, 0, trade.Shopid)/**/,
                                                DbHelper.MakeInParam("@tradename", (DbType)SqlDbType.NChar, 20, trade.Tradename)/**/,
                                                DbHelper.MakeInParam("@tradevalue", (DbType)SqlDbType.Decimal, 0, trade.Tradevalue)/**/
                                          };
            
            string s = DbHelper.ExecuteScalar(CommandType.Text, cmdText, cmdParameters).ToString();
            int i = (string.IsNullOrEmpty(s) ? 0 : int.Parse(s));
            return i;
        }

        public int AddTrade(Trade trade, DbTransaction trans)
        {
            string cmdText = "INSERT INTO Trade(shopid,tradename,tradevalue)VALUES(@shopid,@tradename,@tradevalue);SELECT @@identity";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@shopid", (DbType)SqlDbType.Int, 0, trade.Shopid)/**/,
                                                DbHelper.MakeInParam("@tradename", (DbType)SqlDbType.NChar, 20, trade.Tradename)/**/,
                                                DbHelper.MakeInParam("@tradevalue", (DbType)SqlDbType.Decimal, 0, trade.Tradevalue)/**/
                                          };

            string s = DbHelper.ExecuteScalar(trans, CommandType.Text, cmdText, cmdParameters).ToString();
            int i = (string.IsNullOrEmpty(s) ? 0 : int.Parse(s));
            return i;
        }

        public int DelTrade(int id)
        {
            string cmdText = "DELETE FROM Trade WHERE id=@id";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, id)/**/
                                          };

            return DbHelper.ExecuteNonQuery(CommandType.Text, cmdText, cmdParameters);
        }

        public int DelTrade(int shopid, DbTransaction trans)
        {
            string cmdText = "DELETE FROM Trade WHERE shopid=@shopid";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@shopid", (DbType)SqlDbType.Int, 0, shopid)/**/
                                          };

            return DbHelper.ExecuteNonQuery(trans, CommandType.Text, cmdText, cmdParameters);
        }

        public int UpdateTrade(Trade trade)
        {
            string cmdText = "UPDATE Trade SET shopid=@shopid, tradename=@tradename, tradevalue=@tradevalue WHERE id=@id";

            DbParameter[] cmdParameters = {
                                                
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, trade.Id)/**/,
                                                DbHelper.MakeInParam("@shopid", (DbType)SqlDbType.Int, 0, trade.Shopid)/**/,
                                                DbHelper.MakeInParam("@tradename", (DbType)SqlDbType.NChar, 20, trade.Tradename)/**/,
                                                DbHelper.MakeInParam("@tradevalue", (DbType)SqlDbType.Decimal, 0, trade.Tradevalue)/**/
                                          };

            return DbHelper.ExecuteNonQuery(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetTrade(int id)
        {
            string cmdText = "SELECT * FROM Trade WHERE id=@id ";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, id)/**/
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetTrade(int shopid, bool notUseThisParam)
        {
            string cmdText = "SELECT * FROM Trade WHERE shopid=@id ";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, shopid)/**/
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetTrade()
        {
            string cmdText = "SELECT * FROM Trade";

            DbParameter[] cmdParameters = {
                                                
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetTrade(int pageSize, int currentPage)
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
                cmdText = string.Format("select top {0} * from Trade order by id desc", pageSize.ToString());
            }
            else
            {
                cmdText = string.Format("select top {0} * from Trade where id < (select min(id) from (select top {1} id from Trade order by id desc) as tblTmp) order by id desc", pageSize.ToString(), pagetop.ToString());
            }
            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

    }
}
