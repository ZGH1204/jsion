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
        public int AddBookingtrade(Bookingtrade bookingtrade)
        {
            string cmdText = "INSERT INTO BookingTrade(bookingshopid,bookingid,bookingname,shopid,shopname,handlerid,handlername,proxyid,proxyname,uid,realname,tradeid,tradename,tradevalue,tradecount,issettle,bookinttime,remarks)VALUES(@bookingshopid,@bookingid,@bookingname,@shopid,@shopname,@handlerid,@handlername,@proxyid,@proxyname,@uid,@realname,@tradeid,@tradename,@tradevalue,@tradecount,@issettle,@bookinttime,@remarks);SELECT @@identity";

            DbParameter[] cmdParameters = {
                    DbHelper.MakeInParam("@bookingshopid", (DbType)SqlDbType.Int, 0, bookingtrade.Bookingshopid)/**/,
                    DbHelper.MakeInParam("@bookingid", (DbType)SqlDbType.Int, 0, bookingtrade.Bookingid)/**/,
                    DbHelper.MakeInParam("@bookingname", (DbType)SqlDbType.NChar, 50, bookingtrade.Bookingname)/**/,
                    DbHelper.MakeInParam("@shopid", (DbType)SqlDbType.Int, 0, bookingtrade.Shopid)/**/,
                    DbHelper.MakeInParam("@shopname", (DbType)SqlDbType.NChar, 20, bookingtrade.Shopname)/**/,
                    DbHelper.MakeInParam("@handlerid", (DbType)SqlDbType.Int, 0, bookingtrade.Handlerid)/**/,
                    DbHelper.MakeInParam("@handlername", (DbType)SqlDbType.NChar, 10, bookingtrade.Handlername)/**/,
                    DbHelper.MakeInParam("@proxyid", (DbType)SqlDbType.Int, 0, bookingtrade.Proxyid)/**/,
                    DbHelper.MakeInParam("@proxyname", (DbType)SqlDbType.NChar, 10, bookingtrade.Proxyname)/**/,
                    DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, bookingtrade.Uid)/**/,
                    DbHelper.MakeInParam("@realname", (DbType)SqlDbType.NChar, 10, bookingtrade.Realname)/**/,
                    DbHelper.MakeInParam("@tradeid", (DbType)SqlDbType.Int, 0, bookingtrade.Tradeid)/**/,
                    DbHelper.MakeInParam("@tradename", (DbType)SqlDbType.NChar, 20, bookingtrade.Tradename)/**/,
                    DbHelper.MakeInParam("@tradevalue", (DbType)SqlDbType.Decimal, 0, bookingtrade.Tradevalue)/**/,
                    DbHelper.MakeInParam("@tradecount", (DbType)SqlDbType.Int, 0, bookingtrade.Tradecount)/**/,
                    DbHelper.MakeInParam("@issettle", (DbType)SqlDbType.Bit, 0, bookingtrade.Issettle)/**/,
                    DbHelper.MakeInParam("@bookinttime", (DbType)SqlDbType.DateTime, 0, bookingtrade.Bookinttime)/**/,
                    DbHelper.MakeInParam("@remarks", (DbType)SqlDbType.NChar, 100, bookingtrade.Remarks)/**/
                };

            string s = DbHelper.ExecuteScalar(CommandType.Text, cmdText, cmdParameters).ToString();
            int i = (string.IsNullOrEmpty(s) ? 0 : int.Parse(s));
            return i;
        }

        public int AddBookingtrade(Bookingtrade bookingtrade, DbTransaction trans)
        {
            string cmdText = "INSERT INTO BookingTrade(bookingshopid,bookingid,bookingname,shopid,shopname,handlerid,handlername,proxyid,proxyname,uid,realname,tradeid,tradename,tradevalue,tradecount,issettle,bookinttime,remarks)VALUES(@bookingshopid,@bookingid,@bookingname,@shopid,@shopname,@handlerid,@handlername,@proxyid,@proxyname,@uid,@realname,@tradeid,@tradename,@tradevalue,@tradecount,@issettle,@bookinttime,@remarks);SELECT @@identity";

            DbParameter[] cmdParameters = {
                    DbHelper.MakeInParam("@bookingshopid", (DbType)SqlDbType.Int, 0, bookingtrade.Bookingshopid)/**/,
                    DbHelper.MakeInParam("@bookingid", (DbType)SqlDbType.Int, 0, bookingtrade.Bookingid)/**/,
                    DbHelper.MakeInParam("@bookingname", (DbType)SqlDbType.NChar, 50, bookingtrade.Bookingname)/**/,
                    DbHelper.MakeInParam("@shopid", (DbType)SqlDbType.Int, 0, bookingtrade.Shopid)/**/,
                    DbHelper.MakeInParam("@shopname", (DbType)SqlDbType.NChar, 20, bookingtrade.Shopname)/**/,
                    DbHelper.MakeInParam("@handlerid", (DbType)SqlDbType.Int, 0, bookingtrade.Handlerid)/**/,
                    DbHelper.MakeInParam("@handlername", (DbType)SqlDbType.NChar, 10, bookingtrade.Handlername)/**/,
                    DbHelper.MakeInParam("@proxyid", (DbType)SqlDbType.Int, 0, bookingtrade.Proxyid)/**/,
                    DbHelper.MakeInParam("@proxyname", (DbType)SqlDbType.NChar, 10, bookingtrade.Proxyname)/**/,
                    DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, bookingtrade.Uid)/**/,
                    DbHelper.MakeInParam("@realname", (DbType)SqlDbType.NChar, 10, bookingtrade.Realname)/**/,
                    DbHelper.MakeInParam("@tradeid", (DbType)SqlDbType.Int, 0, bookingtrade.Tradeid)/**/,
                    DbHelper.MakeInParam("@tradename", (DbType)SqlDbType.NChar, 20, bookingtrade.Tradename)/**/,
                    DbHelper.MakeInParam("@tradevalue", (DbType)SqlDbType.Decimal, 0, bookingtrade.Tradevalue)/**/,
                    DbHelper.MakeInParam("@tradecount", (DbType)SqlDbType.Int, 0, bookingtrade.Tradecount)/**/,
                    DbHelper.MakeInParam("@issettle", (DbType)SqlDbType.Bit, 0, bookingtrade.Issettle)/**/,
                    DbHelper.MakeInParam("@bookinttime", (DbType)SqlDbType.DateTime, 0, bookingtrade.Bookinttime)/**/,
                    DbHelper.MakeInParam("@remarks", (DbType)SqlDbType.NChar, 100, bookingtrade.Remarks)/**/
                };

            string s = DbHelper.ExecuteScalar(trans, CommandType.Text, cmdText, cmdParameters).ToString();
            int i = (string.IsNullOrEmpty(s) ? 0 : int.Parse(s));
            return i;
        }

        public int DelBookingtrade(int id)
        {
            string cmdText = "DELETE FROM BookingTrade WHERE id=@id";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, id)/**/
                                          };

            return DbHelper.ExecuteNonQuery(CommandType.Text, cmdText, cmdParameters);
        }

        public int DelBookingtrade(int bookingid, bool notUseThisParam)
        {
            string cmdText = "DELETE FROM BookingTrade WHERE bookingid=@bookingid";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@bookingid", (DbType)SqlDbType.Int, 0, bookingid)/**/
                                          };

            return DbHelper.ExecuteNonQuery(CommandType.Text, cmdText, cmdParameters);
        }

        public int DelBookingtrade(int bookingid, int bookingshopid, bool notUseThisParam)
        {
            string cmdText = "DELETE FROM BookingTrade WHERE bookingid=@bookingid AND bookingshopid=@bookingshopid";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@bookingid", (DbType)SqlDbType.Int, 0, bookingid)/**/,
                                                DbHelper.MakeInParam("@bookingshopid", (DbType)SqlDbType.Int, 0, bookingshopid)/**/
                                          };

            return DbHelper.ExecuteNonQuery(CommandType.Text, cmdText, cmdParameters);
        }

        public int UpdateBookingtrade(Bookingtrade bookingtrade)
        {
            using (DbTransaction trans = DbHelper.BeginTransaction())
            {
                int i = UpdateBookingtrade(bookingtrade, trans);

                if (i <= 0)
                {
                    trans.Rollback();
                }
                else
                {
                    trans.Commit();
                }

                return i;
            }
        }

        public int UpdateBookingtrade(Bookingtrade bookingtrade, DbTransaction trans)
        {
            string cmdText = "UPDATE BookingTrade SET bookingshopid=@bookingshopid, bookingid=@bookingid, bookingname=@bookingname, shopid=@shopid, shopname=@shopname, handlerid=@handlerid, handlername=@handlername, proxyid=@proxyid, proxyname=@proxyname, uid=@uid, realname=@realname, tradeid=@tradeid, tradename=@tradename, tradevalue=@tradevalue, tradecount=@tradecount, issettle=@issettle, remarks=@remarks WHERE id=@id";

            DbParameter[] cmdParameters2 = {
                        DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, bookingtrade.Id)/**/,
                        DbHelper.MakeInParam("@bookingshopid", (DbType)SqlDbType.Int, 0, bookingtrade.Bookingshopid)/**/,
                        DbHelper.MakeInParam("@bookingid", (DbType)SqlDbType.Int, 0, bookingtrade.Bookingid)/**/,
                        DbHelper.MakeInParam("@bookingname", (DbType)SqlDbType.NChar, 50, bookingtrade.Bookingname)/**/,
                        DbHelper.MakeInParam("@shopid", (DbType)SqlDbType.Int, 0, bookingtrade.Shopid)/**/,
                        DbHelper.MakeInParam("@shopname", (DbType)SqlDbType.NChar, 20, bookingtrade.Shopname)/**/,
                        DbHelper.MakeInParam("@handlerid", (DbType)SqlDbType.Int, 0, bookingtrade.Handlerid)/**/,
                        DbHelper.MakeInParam("@handlername", (DbType)SqlDbType.NChar, 10, bookingtrade.Handlername)/**/,
                        DbHelper.MakeInParam("@proxyid", (DbType)SqlDbType.Int, 0, bookingtrade.Proxyid)/**/,
                        DbHelper.MakeInParam("@proxyname", (DbType)SqlDbType.NChar, 10, bookingtrade.Proxyname)/**/,
                        DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, bookingtrade.Uid)/**/,
                        DbHelper.MakeInParam("@realname", (DbType)SqlDbType.NChar, 10, bookingtrade.Realname)/**/,
                        DbHelper.MakeInParam("@tradeid", (DbType)SqlDbType.Int, 0, bookingtrade.Tradeid)/**/,
                        DbHelper.MakeInParam("@tradename", (DbType)SqlDbType.NChar, 20, bookingtrade.Tradename)/**/,
                        DbHelper.MakeInParam("@tradevalue", (DbType)SqlDbType.Decimal, 0, bookingtrade.Tradevalue)/**/,
                        DbHelper.MakeInParam("@tradecount", (DbType)SqlDbType.Int, 0, bookingtrade.Tradecount)/**/,
                        DbHelper.MakeInParam("@issettle", (DbType)SqlDbType.Bit, 0, bookingtrade.Issettle)/**/,
                        DbHelper.MakeInParam("@remarks", (DbType)SqlDbType.NChar, 100, bookingtrade.Remarks)/**/
                    };

            return DbHelper.ExecuteNonQuery(trans, CommandType.Text, cmdText, cmdParameters2);
        }

        public int DelBookingtrade(int id, DbTransaction trans)
        {
            string cmdText = "DELETE FROM BookingTrade WHERE id=@id";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, id)/**/
                                          };

            int i = DbHelper.ExecuteNonQuery(trans, CommandType.Text, cmdText, cmdParameters);

            return i;
        }

        public int UpdateBookingtrade(int bookingid, bool isbooking)
        {
            string cmdText = "UPDATE BookingTrade SET issettle=@issettle WHERE bookingid=@bookingid";

            DbParameter[] cmdParameters2 = {
                        DbHelper.MakeInParam("@bookingid", (DbType)SqlDbType.Int, 0, bookingid)/**/,
                        DbHelper.MakeInParam("@issettle", (DbType)SqlDbType.Bit, 0, isbooking)/**/
                    };

            return DbHelper.ExecuteNonQuery(CommandType.Text, cmdText, cmdParameters2);
        }

        public System.Data.IDataReader GetBookingtrade(int id)
        {
            string cmdText = "SELECT * FROM BookingTrade WHERE id=@id ";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, id)/**/
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public IDataReader GetBookingtrade(int bookingshopid, int tradeid, bool notUseThisParam)
        {
            string cmdText = "SELECT * FROM BookingTrade WHERE bookingshopid=@bookingshopid AND tradeid=@tradeid";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@bookingshopid", (DbType)SqlDbType.Int, 0, bookingshopid)/**/,
                                                DbHelper.MakeInParam("@tradeid", (DbType)SqlDbType.Int, 0, tradeid)/**/
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public IDataReader GetBookingtrade(int uid, DateTime minDate)
        {
            string cmdText = "SELECT * FROM BookingTrade WHERE (uid=@uid OR proxyid=@uid) AND bookinttime >= @bookinttime";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, uid)/**/,
                                                DbHelper.MakeInParam("@bookinttime", (DbType)SqlDbType.NChar, 20, minDate.ToString("yyyy-MM-dd") + " 00:00:00")/**/
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public IDataReader GetBookingtrade(int bookingid, bool notUseThisParam)
        {
            string cmdText = "SELECT * FROM BookingTrade WHERE bookingid=@bookingid ";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@bookingid", (DbType)SqlDbType.Int, 0, bookingid)/**/
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public IDataReader GetBookingtrade(int bookingshopid, DbTransaction trans)
        {
            string cmdText = "SELECT * FROM BookingTrade WHERE bookingshopid=@bookingshopid ";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@bookingshopid", (DbType)SqlDbType.Int, 0, bookingshopid)/**/
                                          };

            return DbHelper.ExecuteReader(trans, CommandType.Text, cmdText, cmdParameters);
        }

        public IDataReader GetBookingtrade(int bookingid, DbTransaction trans, bool notUseThisParam)
        {
            string cmdText = "SELECT * FROM BookingTrade WHERE bookingid=@bookingid ";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@bookingid", (DbType)SqlDbType.Int, 0, bookingid)/**/
                                          };

            return DbHelper.ExecuteReader(trans, CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetBookingtrade()
        {
            string cmdText = "SELECT * FROM BookingTrade";

            DbParameter[] cmdParameters = {
                                                
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public IDataReader GetBookingtrade(int bookingshopid, int handlerid, int notUseThisParam)
        {
            string cmdText = "SELECT * FROM BookingTrade WHERE bookingshopid=@bookingshopid ORDER BY Tradename";

            if (handlerid > 0)
            {
                cmdText = "SELECT * FROM BookingTrade WHERE bookingshopid=@bookingshopid AND handlerid=@handlerid";
            }

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@bookingshopid", (DbType)SqlDbType.Int, 0, bookingshopid)/**/,
                                                DbHelper.MakeInParam("@handlerid", (DbType)SqlDbType.Int, 0, handlerid)/**/
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public IDataReader GetBookingtrade(int uid, uint unUsedThisParam)
        {
            string cmdText = "SELECT * FROM BookingTrade WHERE uid=@uid";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, uid)/**/
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public int GetBookingtradeCountByUid(int uid)
        {
            string cmdText = "SELECT COUNT(Id) FROM BookingTrade WHERE uid=@uid ";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, uid)/**/
                                          };

            return DbHelper.ExecuteScalarToInt(CommandType.Text, cmdText, cmdParameters);
        }

        public IDataReader GetBookingtrade(int uid, int pageSize, int currentPage, uint unUsedThisParam)
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
                cmdText = string.Format("select top {0} * from BookingTrade WHERE uid=@uid order by id desc", pageSize.ToString());
            }
            else
            {
                cmdText = string.Format("select top {0} * from BookingTrade where uid=@uid AND id < (select min(id) from (select top {1} id from BookingTrade WHERE uid=@uid order by id desc) as tblTmp) order by id desc", pageSize.ToString(), pagetop.ToString());
            }
            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetBookingtrade(int pageSize, int currentPage)
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
                cmdText = string.Format("select top {0} * from BookingTrade order by id desc", pageSize.ToString());
            }
            else
            {
                cmdText = string.Format("select top {0} * from BookingTrade where id < (select min(id) from (select top {1} id from BookingTrade order by id desc) as tblTmp) order by id desc", pageSize.ToString(), pagetop.ToString());
            }
            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

    }
}
