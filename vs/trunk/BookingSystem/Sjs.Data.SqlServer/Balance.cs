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
        public int AddBalance(Balance balance)
        {
            string cmdText = "INSERT INTO Balance(uid,balances,btime,remarks)VALUES(@uid,@balance,@btime,@remarks);SELECT @@identity";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, balance.Uid)/**/,
                                                DbHelper.MakeInParam("@balance", (DbType)SqlDbType.Decimal, 0, balance.Balances)/**/,
                                                DbHelper.MakeInParam("@btime", (DbType)SqlDbType.DateTime, 0, balance.Btime)/**/,
                                                DbHelper.MakeInParam("@remarks", (DbType)SqlDbType.NChar, 200, balance.Remarks)/**/
                                          };
            
            string s = DbHelper.ExecuteScalar(CommandType.Text, cmdText, cmdParameters).ToString();
            int i = (string.IsNullOrEmpty(s) ? 0 : int.Parse(s));
            return i;
        }

        public int AddBalance(Balance balances, DbTransaction trans)
        {
            string cmdText = "INSERT INTO Balance(uid,balances,btime,remarks)VALUES(@uid,@balance,@btime,@remarks);SELECT @@identity";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, balances.Uid)/**/,
                                                DbHelper.MakeInParam("@balance", (DbType)SqlDbType.Decimal, 0, balances.Balances)/**/,
                                                DbHelper.MakeInParam("@btime", (DbType)SqlDbType.DateTime, 0, balances.Btime)/**/,
                                                DbHelper.MakeInParam("@remarks", (DbType)SqlDbType.NChar, 200, balances.Remarks)/**/
                                          };

            string s = DbHelper.ExecuteScalar(trans, CommandType.Text, cmdText, cmdParameters).ToString();
            int i = (string.IsNullOrEmpty(s) ? 0 : int.Parse(s));
            return i;
        }

        public int DelBalance(int id)
        {
            string cmdText = "DELETE FROM Balance WHERE id=@id";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, id)/**/
                                          };

            return DbHelper.ExecuteNonQuery(CommandType.Text, cmdText, cmdParameters);
        }

        public int UpdateBalance(Balance balance)
        {
            string cmdText = "UPDATE Balance SET uid=@uid, balances=@balance, remarks=@remarks WHERE id=@id";

            DbParameter[] cmdParameters = {
                                                
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, balance.Id)/**/,
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, balance.Uid)/**/,
                                                DbHelper.MakeInParam("@balance", (DbType)SqlDbType.Decimal, 0, balance.Balances)/**/,
                                                DbHelper.MakeInParam("@remarks", (DbType)SqlDbType.NChar, 200, balance.Remarks)/**/
                                          };

            return DbHelper.ExecuteNonQuery(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetBalance(int id)
        {
            string cmdText = "SELECT * FROM Balance WHERE id=@id ";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, id)/**/
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetBalance(int id, bool notUseThisParam)
        {
            string cmdText = "SELECT * FROM Balance WHERE uid=@id ";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, id)/**/
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetBalance()
        {
            string cmdText = "SELECT * FROM Balance";

            DbParameter[] cmdParameters = {
                                                
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetBalance(int pageSize, int currentPage)
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
                cmdText = string.Format("select top {0} * from Balance order by id desc", pageSize.ToString());
            }
            else
            {
                cmdText = string.Format("select top {0} * from Balance where id < (select min(id) from (select top {1} id from Balance order by id desc) as tblTmp) order by id desc", pageSize.ToString(), pagetop.ToString());
            }
            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

    }
}
