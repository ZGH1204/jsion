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
        public int AddBookingshop(Bookingshop bookingshop)
        {
            string cmdText = "INSERT INTO BookingShop(bookingid,bookingname,uid,realname,shopid,shopname,begintime,isover)VALUES(@bookingid,@bookingname,@uid,@realname,@shopid,@shopname,@begintime,@isover);SELECT @@identity";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@bookingid", (DbType)SqlDbType.Int, 0, bookingshop.Bookingid)/**/,
                                                DbHelper.MakeInParam("@bookingname", (DbType)SqlDbType.NChar, 20, bookingshop.Bookingname)/**/,
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, bookingshop.Uid)/**/,
                                                DbHelper.MakeInParam("@realname", (DbType)SqlDbType.NChar, 10, bookingshop.Realname)/**/,
                                                DbHelper.MakeInParam("@shopid", (DbType)SqlDbType.Int, 0, bookingshop.Shopid)/**/,
                                                DbHelper.MakeInParam("@shopname", (DbType)SqlDbType.NChar, 20, bookingshop.Shopname)/**/,
                                                DbHelper.MakeInParam("@begintime", (DbType)SqlDbType.DateTime, 0, bookingshop.Begintime)/**/,
                                                DbHelper.MakeInParam("@isover", (DbType)SqlDbType.Bit, 0, bookingshop.Isover)/**/
                                          };
            
            string s = DbHelper.ExecuteScalar(CommandType.Text, cmdText, cmdParameters).ToString();
            int i = (string.IsNullOrEmpty(s) ? 0 : int.Parse(s));
            return i;
        }

        public int DelBookingshop(int id)
        {
            string cmdText = "DELETE FROM BookingShop WHERE id=@id";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, id)/**/
                                          };

            return DbHelper.ExecuteNonQuery(CommandType.Text, cmdText, cmdParameters);
        }

        public int DelBookingshop(int id, DbTransaction trans)
        {
            string cmdText = "DELETE FROM BookingShop WHERE id=@id";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, id)/**/
                                          };

            return DbHelper.ExecuteNonQuery(trans, CommandType.Text, cmdText, cmdParameters);
        }

        public int DelBookingshop(int bookingid, bool notUseThisParam)
        {
            string cmdText = "DELETE FROM BookingShop WHERE bookingid=@bookingid";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@bookingid", (DbType)SqlDbType.Int, 0, bookingid)/**/
                                          };

            return DbHelper.ExecuteNonQuery(CommandType.Text, cmdText, cmdParameters);
        }

        public int DelBookingshop(int bookingid, bool notUseThisParam, DbTransaction trans)
        {
            string cmdText = "DELETE FROM BookingShop WHERE bookingid=@bookingid";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@bookingid", (DbType)SqlDbType.Int, 0, bookingid)/**/
                                          };

            return DbHelper.ExecuteNonQuery(CommandType.Text, cmdText, cmdParameters);
        }

        public int UpdateBookingshop(Bookingshop bookingshop)
        {
            string cmdText = "UPDATE BookingShop SET bookingid=@bookingid, bookingname=@bookingname, uid=@uid, realname=@realname, shopid=@shopid, shopname=@shopname, isover=@isover WHERE id=@id";

            DbParameter[] cmdParameters = {
                                                
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, bookingshop.Id)/**/,
                                                DbHelper.MakeInParam("@bookingid", (DbType)SqlDbType.Int, 0, bookingshop.Bookingid)/**/,
                                                DbHelper.MakeInParam("@bookingname", (DbType)SqlDbType.NChar, 20, bookingshop.Bookingname)/**/,
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, bookingshop.Uid)/**/,
                                                DbHelper.MakeInParam("@realname", (DbType)SqlDbType.NChar, 10, bookingshop.Realname)/**/,
                                                DbHelper.MakeInParam("@shopid", (DbType)SqlDbType.Int, 0, bookingshop.Shopid)/**/,
                                                DbHelper.MakeInParam("@shopname", (DbType)SqlDbType.NChar, 20, bookingshop.Shopname)/**/,
                                                DbHelper.MakeInParam("@isover", (DbType)SqlDbType.Bit, 0, bookingshop.Isover)/**/
                                          };

            return DbHelper.ExecuteNonQuery(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetBookingshop(int id)
        {
            string cmdText = "SELECT * FROM BookingShop WHERE id=@id ";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, id)/**/
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public int GetBookingshop(int id, bool isover, bool shopidOrTradeid)
        {
            string cmdText;
            if (shopidOrTradeid)
            {
                cmdText = "SELECT COUNT(id) FROM BookingShop WHERE shopid=@id AND isover=@isover ";
            }
            else
            {
                cmdText = "SELECT COUNT(id) FROM BookingShop WHERE tradeid=@id AND isover=@isover ";
            }

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, id)/**/,
                                                DbHelper.MakeInParam("@isover", (DbType)SqlDbType.Bit, 0, isover)/**/
                                          };

            return DbHelper.ExecuteScalarToInt(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetBookingshop(DateTime minDate)
        {
            string cmdText = "SELECT * FROM BookingShop WHERE begintime>=@begintime";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@begintime", (DbType)SqlDbType.NChar, 20, minDate.ToString("yyyy-MM-dd") + " 00:00:00")/**/
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetBookingshop(DateTime minDate, bool isOver)
        {
            string cmdText = "SELECT * FROM BookingShop WHERE begintime>=@begintime AND isover=@isover";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@begintime", (DbType)SqlDbType.NChar, 20, minDate.ToString("yyyy-MM-dd") + " 00:00:00")/**/,
                                                DbHelper.MakeInParam("@isover", (DbType)SqlDbType.Bit, 0, isOver)/**/
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetBookingshop(DateTime specifiedDate, int uid)
        {
            string cmdText = "SELECT * FROM BookingShop WHERE begintime >= @begintime1 AND begintime <= @begintime2";

            if (uid > 0)
            {
                cmdText = "SELECT * FROM BookingShop WHERE begintime >= @begintime1 AND begintime <= @begintime2  AND uid=@uid";
            }

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@begintime1", (DbType)SqlDbType.NChar, 20, specifiedDate.ToString("yyyy-MM-dd") + " 00:00:00")/**/,
                                                DbHelper.MakeInParam("@begintime2", (DbType)SqlDbType.NChar, 20, specifiedDate.ToString("yyyy-MM-dd") + " 23:59:59")/**/,
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, uid)/**/
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public IDataReader GetBookingshop(int bookingId, bool notUseThisParam)
        {
            string cmdText = "SELECT * FROM BookingShop WHERE bookingid=@bookingid ";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@bookingid", (DbType)SqlDbType.Int, 0, bookingId)/**/
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public IDataReader GetBookingshop(int bookingId, int uid, bool notUseThisParam)
        {
            string cmdText = "SELECT * FROM BookingShop WHERE bookingid=@bookingid AND uid=@uid";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@bookingid", (DbType)SqlDbType.Int, 0, bookingId)/**/,
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, uid)/**/
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetBookingshop(int bookingId, int shopId, int uid)
        {
            string cmdText = "SELECT * FROM BookingShop WHERE bookingid=@bookingid AND shopid=@shopid AND uid=@uid";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@bookingid", (DbType)SqlDbType.Int, 0, bookingId)/**/,
                                                DbHelper.MakeInParam("@shopid", (DbType)SqlDbType.Int, 0, shopId)/**/,
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, uid)/**/
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetBookingshop()
        {
            string cmdText = "SELECT * FROM BookingShop";

            DbParameter[] cmdParameters = {
                                                
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetBookingshop(int pageSize, int currentPage)
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
                cmdText = string.Format("select top {0} * from BookingShop order by id desc", pageSize.ToString());
            }
            else
            {
                cmdText = string.Format("select top {0} * from BookingShop where id < (select min(id) from (select top {1} id from BookingShop order by id desc) as tblTmp) order by id desc", pageSize.ToString(), pagetop.ToString());
            }
            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

    }
}
