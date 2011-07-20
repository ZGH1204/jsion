using System;
using System.Collections.Generic;
using System.Text;

using SJSCAN.Entity;
using Sjs.Data;
using System.Data;
using System.Data.Common;

namespace SJSCAN.BLL
{
    public partial class BookingshopManager
    {
        /// <summary>
        /// 添加方法
        /// </summary>
        public static int AddBookingshop(Bookingshop bookingshop)
        {
            return DatabaseProvider.GetInstance().AddBookingshop(bookingshop);
        }

        /// <summary>
        /// 删除方法
        /// </summary>
        public static int DelBookingshop(int id)
        {
            return DatabaseProvider.GetInstance().DelBookingshop(id);
        }

        /// <summary>
        /// 删除方法
        /// </summary>
        public static int DelBookingshop(int id, DbTransaction trans)
        {
            return DatabaseProvider.GetInstance().DelBookingshop(id, trans);
        }

        public static int DelBookingshop(int bookingid, bool notUseThisParam)
        {
            return DatabaseProvider.GetInstance().DelBookingshop(bookingid, notUseThisParam);
        }

        public static int DelBookingshop(int bookingid, bool notUseThisParam, DbTransaction trans)
        {
            return DatabaseProvider.GetInstance().DelBookingshop(bookingid, notUseThisParam, trans);
        }

        /// <summary>
        /// 修改方法
        /// </summary>
        public static int UpdateBookingshop(Bookingshop bookingshop)
        {
            return DatabaseProvider.GetInstance().UpdateBookingshop(bookingshop);
        }

        public static Bookingshop GetBookingshop(int id)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBookingshop(id);

            Bookingshop model = null;

            if(reader.Read())
            {
                model = GetBookingshop(reader);
            }

            reader.Close();
            return model;
        }

        public static int GetBookingshop(int shopid, bool isover, bool notUseThisParam)
        {
            return DatabaseProvider.GetInstance().GetBookingshop(shopid, isover, notUseThisParam);
        }

        public static IList<Bookingshop> GetBookingshop(  )
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBookingshop( );

            IList<Bookingshop> list = new List<Bookingshop>();

            while(reader.Read())
            {
                Bookingshop model = GetBookingshop(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static IList<Bookingshop> GetBookingshop(DateTime specifiedDate, int uid)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBookingshop(specifiedDate, uid);

            IList<Bookingshop> list = new List<Bookingshop>();

            while(reader.Read())
            {
                Bookingshop model = GetBookingshop(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static Bookingshop GetBookingshop(int bookingId, int shopId, int uid)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBookingshop(bookingId, shopId, uid);

            Bookingshop model = null;

            if (reader.Read())
            {
                model = GetBookingshop(reader);
            }

            reader.Close();
            return model;
        }

        public static IList<Bookingshop> GetBookingshop(int pageSize, int  currentPage)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBookingshop(pageSize, currentPage);

            IList<Bookingshop> list = new List<Bookingshop>();

            while(reader.Read())
            {
                Bookingshop model = GetBookingshop(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static Bookingshop GetBookingshop(IDataReader reader)
        {
            Bookingshop model = new Bookingshop();

            model.Id = (reader["Id"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Id"]));
            model.Bookingid = (reader["Bookingid"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Bookingid"]));
            model.Bookingname = reader["Bookingname"].ToString();
            model.Uid = (reader["Uid"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Uid"]));
            model.Realname = reader["Realname"].ToString();
            model.Shopid = (reader["Shopid"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Shopid"]));
            model.Shopname = reader["Shopname"].ToString();
            model.Begintime = (reader["Begintime"] is DBNull ? Convert.ToDateTime("1900-01-01") : Convert.ToDateTime(reader["Begintime"]));
            model.Isover = (reader["Isover"] is DBNull ? Convert.ToBoolean("false") : Convert.ToBoolean(reader["Isover"]));


            return model;
        }


        public static IList<Bookingshop> GetBookingshop(DateTime minDate)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBookingshop(minDate);

            IList<Bookingshop> list = new List<Bookingshop>();

            while (reader.Read())
            {
                Bookingshop model = GetBookingshop(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }


        public static IList<Bookingshop> GetBookingshop(DateTime minDate, bool isOver)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBookingshop(minDate, isOver);

            IList<Bookingshop> list = new List<Bookingshop>();

            while (reader.Read())
            {
                Bookingshop model = GetBookingshop(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }


        public static IList<Bookingshop> GetBookingshop(int bookingId, bool notUseThisParam)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBookingshop(bookingId, notUseThisParam);

            IList<Bookingshop> list = new List<Bookingshop>();

            while (reader.Read())
            {
                Bookingshop model = GetBookingshop(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static IList<Bookingshop> GetBookingshop(int bookingId, int uid, bool notUseThisParam)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBookingshop(bookingId, uid, notUseThisParam);

            IList<Bookingshop> list = new List<Bookingshop>();

            while (reader.Read())
            {
                Bookingshop model = GetBookingshop(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }
    }
}
