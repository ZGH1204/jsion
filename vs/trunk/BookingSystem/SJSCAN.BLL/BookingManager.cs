using System;
using System.Collections.Generic;
using System.Text;

using SJSCAN.Entity;
using Sjs.Data;
using System.Data;
using System.Data.Common;

namespace SJSCAN.BLL
{
    public partial class BookingManager
    {
        /// <summary>
        /// 添加方法
        /// </summary>
        public static int AddBooking(Booking booking)
        {
            return DatabaseProvider.GetInstance().AddBooking(booking);
        }

        /// <summary>
        /// 删除方法
        /// </summary>
        public static int DelBooking(int id)
        {
            return DatabaseProvider.GetInstance().DelBooking(id);
        }

        /// <summary>
        /// 删除方法
        /// </summary>
        public static int DelBooking(int id, DbTransaction trans)
        {
            return DatabaseProvider.GetInstance().DelBooking(id, trans);
        }

        /// <summary>
        /// 修改方法
        /// </summary>
        public static int UpdateBooking(Booking booking)
        {
            return DatabaseProvider.GetInstance().UpdateBooking(booking);
        }

        public static Booking GetBooking(int id)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBooking(id);

            Booking model = null;

            if(reader.Read())
            {
                model = GetBooking(reader);
            }

            reader.Close();
            return model;
        }

        public static IList<Booking> GetBooking(  )
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBooking( );

            IList<Booking> list = new List<Booking>();

            while(reader.Read())
            {
                Booking model = GetBooking(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static IList<Booking> GetBooking(int pageSize, int  currentPage)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBooking(pageSize, currentPage);

            IList<Booking> list = new List<Booking>();

            while(reader.Read())
            {
                Booking model = GetBooking(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static IList<Booking> GetBooking(bool isbooking, int uid, DateTime dt)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBooking(isbooking, uid, dt);

            IList<Booking> list = new List<Booking>();

            while(reader.Read())
            {
                Booking model = GetBooking(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static IList<Booking> GetBooking(DateTime specifiedDate, int uid)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBooking(specifiedDate, uid);

            IList<Booking> list = new List<Booking>();

            while(reader.Read())
            {
                Booking model = GetBooking(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static IList<Booking> GetBooking(bool isbooking, DateTime specifiedDate)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBooking(isbooking, specifiedDate);

            IList<Booking> list = new List<Booking>();

            while(reader.Read())
            {
                Booking model = GetBooking(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static Booking GetBooking(IDataReader reader)
        {
            Booking model = new Booking();

            model.Id = (reader["Id"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Id"]));
            model.Uid = (reader["Uid"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Uid"]));
            model.Realname = reader["Realname"].ToString();
            model.Bookingname = reader["Bookingname"].ToString();
            model.Bookingtime = (reader["Bookingtime"] is DBNull ? Convert.ToDateTime("1900-01-01") : Convert.ToDateTime(reader["Bookingtime"]));
            model.Isbooking = (reader["Isbooking"] is DBNull ? Convert.ToBoolean("false") : Convert.ToBoolean(reader["Isbooking"]));
            model.Issettle = (reader["Issettle"] is DBNull ? Convert.ToBoolean("false") : Convert.ToBoolean(reader["Issettle"]));
            model.Haserror = (reader["Haserror"] is DBNull ? Convert.ToBoolean("false") : Convert.ToBoolean(reader["Haserror"]));

            return model;
        }

    }
}
