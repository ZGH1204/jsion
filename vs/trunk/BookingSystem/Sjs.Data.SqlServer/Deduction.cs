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
        public int AddDeduction(Deduction deduction)
        {
            string cmdText = "INSERT INTO Deduction(uid,realname,shopid,shopname,deductionname,deductionvalue,deductioncount,deductionbalance,remarks)VALUES(@uid,@realname,@shopid,@shopname,@deductionname,@deductionvalue,@deductioncount,@deductionbalance,@remarks);SELECT @@identity";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, deduction.Uid)/**/,
                                                DbHelper.MakeInParam("@realname", (DbType)SqlDbType.NChar, 10, deduction.Realname)/**/,
                                                DbHelper.MakeInParam("@shopid", (DbType)SqlDbType.Int, 0, deduction.Shopid)/**/,
                                                DbHelper.MakeInParam("@shopname", (DbType)SqlDbType.NChar, 20, deduction.Shopname)/**/,
                                                DbHelper.MakeInParam("@deductionname", (DbType)SqlDbType.NChar, 100, deduction.Deductionname)/**/,
                                                DbHelper.MakeInParam("@deductionvalue", (DbType)SqlDbType.Decimal, 0, deduction.Deductionvalue)/**/,
                                                DbHelper.MakeInParam("@deductioncount", (DbType)SqlDbType.Int, 0, deduction.Deductioncount)/**/,
                                                DbHelper.MakeInParam("@deductionbalance", (DbType)SqlDbType.Decimal, 0, deduction.Deductionbalance)/**/,
                                                DbHelper.MakeInParam("@remarks", (DbType)SqlDbType.NChar, 100, deduction.Remarks)/**/
                                          };
            
            string s = DbHelper.ExecuteScalar(CommandType.Text, cmdText, cmdParameters).ToString();
            int i = (string.IsNullOrEmpty(s) ? 0 : int.Parse(s));
            return i;
        }

        public int AddDeduction(Deduction deduction, DbTransaction trans)
        {
            string cmdText = "INSERT INTO Deduction(uid,realname,shopid,shopname,deductionname,deductionvalue,deductioncount,deductionbalance,remarks)VALUES(@uid,@realname,@shopid,@shopname,@deductionname,@deductionvalue,@deductioncount,@deductionbalance,@remarks);SELECT @@identity";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, deduction.Uid)/**/,
                                                DbHelper.MakeInParam("@realname", (DbType)SqlDbType.NChar, 10, deduction.Realname)/**/,
                                                DbHelper.MakeInParam("@shopid", (DbType)SqlDbType.Int, 0, deduction.Shopid)/**/,
                                                DbHelper.MakeInParam("@shopname", (DbType)SqlDbType.NChar, 20, deduction.Shopname)/**/,
                                                DbHelper.MakeInParam("@deductionname", (DbType)SqlDbType.NChar, 100, deduction.Deductionname)/**/,
                                                DbHelper.MakeInParam("@deductionvalue", (DbType)SqlDbType.Decimal, 0, deduction.Deductionvalue)/**/,
                                                DbHelper.MakeInParam("@deductioncount", (DbType)SqlDbType.Int, 0, deduction.Deductioncount)/**/,
                                                DbHelper.MakeInParam("@deductionbalance", (DbType)SqlDbType.Decimal, 0, deduction.Deductionbalance)/**/,
                                                DbHelper.MakeInParam("@remarks", (DbType)SqlDbType.NChar, 100, deduction.Remarks)/**/
                                          };

            string s = DbHelper.ExecuteScalar(trans, CommandType.Text, cmdText, cmdParameters).ToString();
            int i = (string.IsNullOrEmpty(s) ? 0 : int.Parse(s));
            return i;
        }

        public int DelDeduction(int id)
        {
            string cmdText = "DELETE FROM Deduction WHERE id=@id";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, id)/**/
                                          };

            return DbHelper.ExecuteNonQuery(CommandType.Text, cmdText, cmdParameters);
        }

        public int UpdateDeduction(Deduction deduction)
        {
            string cmdText = "UPDATE Deduction SET uid=@uid, realname=@realname, shopid=@shopid, shopname=@shopname, deductionname=@deductionname, deductionvalue=@deductionvalue, deductioncount=@deductioncount, deductionbalance=@deductionbalance, deductiontime=getdate(), remarks=@remarks WHERE id=@id";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, deduction.Id)/**/,
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, deduction.Uid)/**/,
                                                DbHelper.MakeInParam("@realname", (DbType)SqlDbType.NChar, 10, deduction.Realname)/**/,
                                                DbHelper.MakeInParam("@shopid", (DbType)SqlDbType.Int, 0, deduction.Shopid)/**/,
                                                DbHelper.MakeInParam("@shopname", (DbType)SqlDbType.NChar, 20, deduction.Shopname)/**/,
                                                DbHelper.MakeInParam("@deductionname", (DbType)SqlDbType.NChar, 100, deduction.Deductionname)/**/,
                                                DbHelper.MakeInParam("@deductionvalue", (DbType)SqlDbType.Decimal, 0, deduction.Deductionvalue)/**/,
                                                DbHelper.MakeInParam("@deductioncount", (DbType)SqlDbType.Int, 0, deduction.Deductioncount)/**/,
                                                DbHelper.MakeInParam("@deductionbalance", (DbType)SqlDbType.Decimal, 0, deduction.Deductionbalance)/**/,
                                                DbHelper.MakeInParam("@remarks", (DbType)SqlDbType.NChar, 100, deduction.Remarks)/**/
                                          };

            return DbHelper.ExecuteNonQuery(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetDeduction(int id)
        {
            string cmdText = "SELECT * FROM Deduction WHERE id=@id ";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, id)/**/
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetDeduction(int uid, bool unUsedThisParam)
        {
            string cmdText = "SELECT * FROM Deduction WHERE uid=@uid ";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, uid)/**/
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public int GetDeductionCount(int uid)
        {
            string cmdText = "SELECT COUNT(Id) FROM Deduction WHERE uid=@uid ";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, uid)/**/
                                          };

            return DbHelper.ExecuteScalarToInt(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetDeduction(int uid, int pageSize, int currentPage)
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

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, uid)/**/
                                          };

            string cmdText = "";

            if (currentPage == 1)
            {
                cmdText = string.Format("select top {0} * from Deduction WHERE uid=@uid order by id desc", pageSize.ToString());
            }
            else
            {
                cmdText = string.Format("select top {0} * from Deduction where uid=@uid AND id < (select min(id) from (select top {1} id from Deduction WHERE uid=@uid order by id desc) as tblTmp) order by id desc", pageSize.ToString(), pagetop.ToString());
            }
            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetDeduction()
        {
            string cmdText = "SELECT * FROM Deduction";

            DbParameter[] cmdParameters = {
                                                
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetDeduction(int pageSize, int currentPage)
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
                cmdText = string.Format("select top {0} * from Deduction order by id desc", pageSize.ToString());
            }
            else
            {
                cmdText = string.Format("select top {0} * from Deduction where id < (select min(id) from (select top {1} id from Deduction order by id desc) as tblTmp) order by id desc", pageSize.ToString(), pagetop.ToString());
            }
            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

    }
}
