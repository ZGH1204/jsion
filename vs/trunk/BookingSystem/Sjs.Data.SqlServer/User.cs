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
        public int AddUser(User user)
        {
            string cmdText = "INSERT INTO [User](account,passwd,realname,balance,type)VALUES(@account,@passwd,@realname,@balance,@type);SELECT @@identity";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@account", (DbType)SqlDbType.NChar, 50, user.Account)/**/,
                                                DbHelper.MakeInParam("@passwd", (DbType)SqlDbType.NChar, 40, user.Passwd)/**/,
                                                DbHelper.MakeInParam("@realname", (DbType)SqlDbType.NChar, 10, user.Realname)/**/,
                                                DbHelper.MakeInParam("@balance", (DbType)SqlDbType.Decimal, 0, user.Balance)/**/,
                                                DbHelper.MakeInParam("@type", (DbType)SqlDbType.Int, 0, user.Type)/**/
                                          };
            
            string s = DbHelper.ExecuteScalar(CommandType.Text, cmdText, cmdParameters).ToString();
            int i = (string.IsNullOrEmpty(s) ? 0 : int.Parse(s));
            return i;
        }

        public int AddUser(User user, DbTransaction trans)
        {
            string cmdText = "INSERT INTO [User](account,passwd,realname,balance,type)VALUES(@account,@passwd,@realname,@balance,@type);SELECT @@identity";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@account", (DbType)SqlDbType.NChar, 50, user.Account)/**/,
                                                DbHelper.MakeInParam("@passwd", (DbType)SqlDbType.NChar, 40, user.Passwd)/**/,
                                                DbHelper.MakeInParam("@realname", (DbType)SqlDbType.NChar, 10, user.Realname)/**/,
                                                DbHelper.MakeInParam("@balance", (DbType)SqlDbType.Decimal, 0, user.Balance)/**/,
                                                DbHelper.MakeInParam("@type", (DbType)SqlDbType.Int, 0, user.Type)/**/
                                          };

            string s = DbHelper.ExecuteScalar(trans, CommandType.Text, cmdText, cmdParameters).ToString();
            int i = (string.IsNullOrEmpty(s) ? 0 : int.Parse(s));
            return i;
        }

        public int DelUser(int id)
        {
            string cmdText = "DELETE FROM [User] WHERE uid=@uid";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, id)/**/
                                          };

            return DbHelper.ExecuteNonQuery(CommandType.Text, cmdText, cmdParameters);
        }

        public int UpdateUser(User user)
        {
            string cmdText = "UPDATE [User] SET account=@account, passwd=@passwd, realname=@realname, balance=@balance, type=@type WHERE uid=@uid";

            DbParameter[] cmdParameters = {
                                                
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, user.Uid)/**/,
                                                DbHelper.MakeInParam("@account", (DbType)SqlDbType.NChar, 50, user.Account)/**/,
                                                DbHelper.MakeInParam("@passwd", (DbType)SqlDbType.NChar, 40, user.Passwd)/**/,
                                                DbHelper.MakeInParam("@realname", (DbType)SqlDbType.NChar, 10, user.Realname)/**/,
                                                DbHelper.MakeInParam("@balance", (DbType)SqlDbType.Decimal, 0, user.Balance)/**/,
                                                DbHelper.MakeInParam("@type", (DbType)SqlDbType.Int, 0, user.Type)/**/
                                          };

            return DbHelper.ExecuteNonQuery(CommandType.Text, cmdText, cmdParameters);
        }

        public int UpdateUser(int uid, double balance)
        {
            string cmdText = "UPDATE [User] SET balance=@balance WHERE uid=@uid";

            DbParameter[] cmdParameters = {
                                                
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, uid)/**/,
                                                DbHelper.MakeInParam("@balance", (DbType)SqlDbType.Decimal, 0, balance)/**/
                                          };

            return DbHelper.ExecuteNonQuery(CommandType.Text, cmdText, cmdParameters);
        }

        public int UpdateUser(int uid, double balance, DbTransaction trans)
        {
            string cmdText = "UPDATE [User] SET balance=@balance WHERE uid=@uid";

            DbParameter[] cmdParameters = {
                                                
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, uid)/**/,
                                                DbHelper.MakeInParam("@balance", (DbType)SqlDbType.Decimal, 0, balance)/**/
                                          };

            return DbHelper.ExecuteNonQuery(trans, CommandType.Text, cmdText, cmdParameters);
        }

        public int UpdateUserBalance(int uid, double tradevalue)
        {
            string cmdText = "UPDATE [User] SET balance = balance - @tradevalue WHERE uid=@uid";

            DbParameter[] cmdParameters = {
                        DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, uid)/**/,
                        DbHelper.MakeInParam("@tradevalue", (DbType)SqlDbType.Decimal, 0, tradevalue)/**/
                    };
            return DbHelper.ExecuteNonQuery(CommandType.Text, cmdText, cmdParameters);
        }

        public int UpdateUserBalance(int uid, double tradevalue, DbTransaction trans)
        {
            string cmdText = "UPDATE [User] SET balance = balance - @tradevalue WHERE uid=@uid";

            DbParameter[] cmdParameters = {
                        DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, uid)/**/,
                        DbHelper.MakeInParam("@tradevalue", (DbType)SqlDbType.Decimal, 0, tradevalue)/**/
                    };
            return DbHelper.ExecuteNonQuery(trans, CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetUser(int id)
        {
            string cmdText = "SELECT * FROM [User] WHERE uid=@uid ";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, id)/**/
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetUser(int uid, DbTransaction trans)
        {
            string cmdText = "SELECT * FROM [User] WHERE uid=@uid ";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, uid)/**/
                                          };

            return DbHelper.ExecuteReader(trans, CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetUser()
        {
            string cmdText = "SELECT * FROM [User]";

            DbParameter[] cmdParameters = {
                                                
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetUser(int pageSize, int currentPage)
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
                cmdText = string.Format("select top {0} * from [User] order by id desc", pageSize.ToString());
            }
            else
            {
                cmdText = string.Format("select top {0} * from [User] where uid < (select min(uid) from (select top {1} uid from User order by uid desc) as tblTmp) order by uid desc", pageSize.ToString(), pagetop.ToString());
            }
            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }


        public System.Data.IDataReader GetUser(string account)
        {
            string cmdText = "SELECT * FROM [User] WHERE account=@account";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@account", (DbType)SqlDbType.NChar, 50, account)
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetUser(string account, string passwd)
        {
            string cmdText = "SELECT * FROM [User] WHERE account=@account AND passwd=@passwd";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@account", (DbType)SqlDbType.NChar, 50, account),
                                                DbHelper.MakeInParam("@passwd", (DbType)SqlDbType.NChar, 40, passwd)
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }


        public int DisableUser(int uid, bool disable)
        {
            bool enabled = !disable;

            string cmdText = "UPDATE [User] SET enabled = @enabled WHERE uid=@uid";

            DbParameter[] cmdParameters = {
                        DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, uid)/**/,
                        DbHelper.MakeInParam("@enabled", (DbType)SqlDbType.Bit, 0, enabled)/**/
                    };
            return DbHelper.ExecuteNonQuery(CommandType.Text, cmdText, cmdParameters);
        }
    }
}
