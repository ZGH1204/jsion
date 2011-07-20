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
        public int AddBooking(Booking booking)
        {
            string cmdText = "INSERT INTO Booking(uid,realname,bookingname,bookingtime,isbooking,issettle,haserror)VALUES(@uid,@realname,@bookingname,@bookingtime,@isbooking,@issettle,@haserror);SELECT @@identity";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, booking.Uid)/**/,
                                                DbHelper.MakeInParam("@realname", (DbType)SqlDbType.NChar, 10, booking.Realname)/**/,
                                                DbHelper.MakeInParam("@bookingname", (DbType)SqlDbType.NChar, 50, booking.Bookingname)/**/,
                                                DbHelper.MakeInParam("@bookingtime", (DbType)SqlDbType.DateTime, 0, booking.Bookingtime)/**/,
                                                DbHelper.MakeInParam("@isbooking", (DbType)SqlDbType.Bit, 0, booking.Isbooking)/**/,
                                                DbHelper.MakeInParam("@issettle", (DbType)SqlDbType.Bit, 0, booking.Issettle)/**/,
                                                DbHelper.MakeInParam("@haserror", (DbType)SqlDbType.Bit, 0, booking.Haserror)/**/
                                          };
            
            string s = DbHelper.ExecuteScalar(CommandType.Text, cmdText, cmdParameters).ToString();
            int i = (string.IsNullOrEmpty(s) ? 0 : int.Parse(s));
            return i;
        }

        public int DelBooking(int id)
        {
            string cmdText = "DELETE FROM Booking WHERE id=@id";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, id)/**/
                                          };

            return DbHelper.ExecuteNonQuery(CommandType.Text, cmdText, cmdParameters);
        }

        public int DelBooking(int id, DbTransaction trans)
        {
            string cmdText = "DELETE FROM Booking WHERE id=@id";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, id)/**/
                                          };

            return DbHelper.ExecuteNonQuery(trans, CommandType.Text, cmdText, cmdParameters);
        }

        public int UpdateBooking(Booking booking)
        {
            string cmdText = "UPDATE Booking SET uid=@uid, realname=@realname, bookingname=@bookingname, isbooking=@isbooking, issettle=@issettle, haserror=@haserror WHERE id=@id";

            DbParameter[] cmdParameters = {
                                                
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, booking.Id)/**/,
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, booking.Uid)/**/,
                                                DbHelper.MakeInParam("@realname", (DbType)SqlDbType.NChar, 10, booking.Realname)/**/,
                                                DbHelper.MakeInParam("@bookingname", (DbType)SqlDbType.NChar, 50, booking.Bookingname)/**/,
                                                DbHelper.MakeInParam("@isbooking", (DbType)SqlDbType.Bit, 0, booking.Isbooking)/**/,
                                                DbHelper.MakeInParam("@issettle", (DbType)SqlDbType.Bit, 0, booking.Issettle)/**/,
                                                DbHelper.MakeInParam("@haserror", (DbType)SqlDbType.Bit, 0, booking.Haserror)/**/
                                          };

            return DbHelper.ExecuteNonQuery(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetBooking(int id)
        {
            string cmdText = "SELECT * FROM Booking WHERE id=@id ";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, id)/**/
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetBooking(bool isbooking, int uid, DateTime minDateTime)
        {
            string cmdText = "SELECT * FROM Booking WHERE bookingtime >= @bookingtime1 AND uid=@uid AND isbooking=@isbooking";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@isbooking", (DbType)SqlDbType.Bit, 0, isbooking)/**/,
                                                DbHelper.MakeInParam("@bookingtime1", (DbType)SqlDbType.DateTime, 0, new DateTime(minDateTime.Year, minDateTime.Month, minDateTime.Day, 0, 0, 0, 0))/**/,
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, uid)/**/
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetBooking(DateTime specifiedDate, int uid)
        {
            string cmdText = "SELECT * FROM Booking WHERE (bookingtime >= @bookingtime1 AND bookingtime <= @bookingtime2 AND uid=@uid)";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@bookingtime1", (DbType)SqlDbType.NChar, 20, specifiedDate.ToString("yyyy-MM-dd") + " 00:00:00")/**/,
                                                DbHelper.MakeInParam("@bookingtime2", (DbType)SqlDbType.NChar, 20, specifiedDate.ToString("yyyy-MM-dd") + " 23:59:59")/**/,
                                                DbHelper.MakeInParam("@uid", (DbType)SqlDbType.Int, 0, uid)/**/
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetBooking(bool isbooking, DateTime specifiedDate)
        {
            string cmdText = "SELECT * FROM Booking WHERE (bookingtime >= @bookingtime1 AND bookingtime <= @bookingtime2 AND isbooking=@isbooking)";

            DbParameter[] cmdParameters = {
                                                DbHelper.MakeInParam("@isbooking", (DbType)SqlDbType.Bit, 0, isbooking)/**/,
                                                DbHelper.MakeInParam("@bookingtime1", (DbType)SqlDbType.NChar, 20, specifiedDate.ToString("yyyy-MM-dd") + " 00:00:00")/**/,
                                                DbHelper.MakeInParam("@bookingtime2", (DbType)SqlDbType.NChar, 20, specifiedDate.ToString("yyyy-MM-dd") + " 23:59:59")/**/
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetBooking()
        {
            string cmdText = "SELECT * FROM Booking";

            DbParameter[] cmdParameters = {
                                                
                                          };

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

        public System.Data.IDataReader GetBooking(int pageSize, int currentPage)
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
                cmdText = string.Format("select top {0} * from Booking order by id desc", pageSize.ToString());
            }
            else
            {
                cmdText = string.Format("select top {0} * from Booking where id < (select min(id) from (select top {1} id from Booking order by id desc) as tblTmp) order by id desc", pageSize.ToString(), pagetop.ToString());
            }
            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }

    }
}
