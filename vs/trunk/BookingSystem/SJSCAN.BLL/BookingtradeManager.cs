using System;
using System.Collections.Generic;
using System.Text;

using SJSCAN.Entity;
using Sjs.Data;
using System.Data;
using System.Data.Common;

namespace SJSCAN.BLL
{
    public partial class BookingtradeManager
    {
        /// <summary>
        /// 添加方法
        /// </summary>
        public static int AddBookingtrade(Bookingtrade bookingtrade)
        {
            return DatabaseProvider.GetInstance().AddBookingtrade(bookingtrade);
        }

        public static int AddBookingtrade(Bookingtrade bookingtrade, DbTransaction trans)
        {
            return DatabaseProvider.GetInstance().AddBookingtrade(bookingtrade, trans);
        }

        /// <summary>
        /// 删除方法
        /// </summary>
        public static int DelBookingtrade(int id)
        {
            return DatabaseProvider.GetInstance().DelBookingtrade(id);
        }

        /// <summary>
        /// 删除方法
        /// </summary>
        public static int DelBookingtrade(int id, DbTransaction trans)
        {
            return DatabaseProvider.GetInstance().DelBookingtrade(id, trans);
        }

        /// <summary>
        /// 删除方法
        /// </summary>
        public static int DelBookingtrade(int bookingid, bool notUseThisParam)
        {
            return DatabaseProvider.GetInstance().DelBookingtrade(bookingid, notUseThisParam);
        }

        /// <summary>
        /// 删除方法
        /// </summary>
        public static int DelBookingtrade(int bookingid, int bookingshopid, bool notUseThisParam)
        {
            return DatabaseProvider.GetInstance().DelBookingtrade(bookingid, bookingshopid, notUseThisParam);
        }

        /// <summary>
        /// 修改方法
        /// </summary>
        public static int UpdateBookingtrade(Bookingtrade bookingtrade)
        {
            return DatabaseProvider.GetInstance().UpdateBookingtrade(bookingtrade);
        }

        public static int UpdateBookingtrade(Bookingtrade bookingtrade, DbTransaction trans)
        {
            return DatabaseProvider.GetInstance().UpdateBookingtrade(bookingtrade, trans);
        }

        public static int UpdateBookingtrade(int bookingid, bool isbooking)
        {
            return DatabaseProvider.GetInstance().UpdateBookingtrade(bookingid, isbooking);
        }

        public static Bookingtrade GetBookingtrade(int id)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBookingtrade(id);

            Bookingtrade model = null;

            if(reader.Read())
            {
                model = GetBookingtrade(reader);
            }

            reader.Close();
            return model;
        }

        public static IList<Bookingtrade> GetBookingtrade(int bookingid, bool notUseThisParam)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBookingtrade(bookingid, notUseThisParam);

            IList<Bookingtrade> list = new List<Bookingtrade>();

            while (reader.Read())
            {
                Bookingtrade model = GetBookingtrade(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static IList<Bookingtrade> GetBookingtrade(int bookingshopid, DbTransaction trans)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBookingtrade(bookingshopid, trans);

            IList<Bookingtrade> list = new List<Bookingtrade>();

            while (reader.Read())
            {
                Bookingtrade model = GetBookingtrade(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static IList<Bookingtrade> GetBookingtrade(int bookingid, DbTransaction trans, bool notUseThisParam)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBookingtrade(bookingid, trans, notUseThisParam);

            IList<Bookingtrade> list = new List<Bookingtrade>();

            while (reader.Read())
            {
                Bookingtrade model = GetBookingtrade(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static IList<Bookingtrade> GetBookingtrade(int uid, uint unUsedThisParam)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBookingtrade(uid, unUsedThisParam);

            IList<Bookingtrade> list = new List<Bookingtrade>();

            while (reader.Read())
            {
                Bookingtrade model = GetBookingtrade(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static int GetBookingtradeCountByUid(int uid)
        {
            return DatabaseProvider.GetInstance().GetBookingtradeCountByUid(uid);
        }

        public static IList<Bookingtrade> GetBookingtrade(int uid, int pageSize, int currentPage, uint unUsedThisParam)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBookingtrade(uid, pageSize, currentPage, unUsedThisParam);

            IList<Bookingtrade> list = new List<Bookingtrade>();

            while (reader.Read())
            {
                Bookingtrade model = GetBookingtrade(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static IList<Bookingtrade> GetBookingtrade(int bookingshopid, int tradeid, bool notUseThisParam)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBookingtrade(bookingshopid, tradeid, notUseThisParam);

            IList<Bookingtrade> list = new List<Bookingtrade>();

            while (reader.Read())
            {
                Bookingtrade model = GetBookingtrade(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static IList<Bookingtrade> GetBookingtrade(int bookingshopid, int handlerid, int notUseThisParam)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBookingtrade(bookingshopid, handlerid, notUseThisParam);

            IList<Bookingtrade> list = new List<Bookingtrade>();

            while (reader.Read())
            {
                Bookingtrade model = GetBookingtrade(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static IList<Bookingtrade> GetBookingtrade(  )
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBookingtrade( );

            IList<Bookingtrade> list = new List<Bookingtrade>();

            while(reader.Read())
            {
                Bookingtrade model = GetBookingtrade(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static IList<Bookingtrade> GetBookingtrade(int uid, DateTime minDate)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBookingtrade(uid, minDate);

            IList<Bookingtrade> list = new List<Bookingtrade>();

            while(reader.Read())
            {
                Bookingtrade model = GetBookingtrade(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static IList<Bookingtrade> GetBookingtrade(int pageSize, int  currentPage)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBookingtrade(pageSize, currentPage);

            IList<Bookingtrade> list = new List<Bookingtrade>();

            while(reader.Read())
            {
                Bookingtrade model = GetBookingtrade(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static Bookingtrade GetBookingtrade(IDataReader reader)
        {
            Bookingtrade model = new Bookingtrade();

            model.Id = (reader["Id"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Id"]));
            model.Bookingshopid = (reader["Bookingshopid"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Bookingshopid"]));
            model.Bookingid = (reader["Bookingid"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Bookingid"]));
            model.Bookingname = reader["Bookingname"].ToString();
            model.Shopid = (reader["Shopid"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Shopid"]));
            model.Shopname = reader["Shopname"].ToString();
            model.Handlerid = (reader["Handlerid"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Handlerid"]));
            model.Handlername = reader["Handlername"].ToString();
            model.Proxyid = (reader["Proxyid"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Proxyid"]));
            model.Proxyname = reader["Proxyname"].ToString();
            model.Uid = (reader["Uid"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Uid"]));
            model.Realname = reader["Realname"].ToString();
            model.Tradeid = (reader["Tradeid"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Tradeid"]));
            model.Tradename = reader["Tradename"].ToString();
            model.Tradevalue = (reader["Tradevalue"] is DBNull ? Convert.ToDouble("0") : Convert.ToDouble(reader["Tradevalue"]));
            model.Tradecount = (reader["Tradecount"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Tradecount"]));
            model.Issettle = (reader["Issettle"] is DBNull ? Convert.ToBoolean("false") : Convert.ToBoolean(reader["Issettle"]));
            model.Bookinttime = (reader["Bookinttime"] is DBNull ? Convert.ToDateTime("1900-01-01") : Convert.ToDateTime(reader["Bookinttime"]));
            model.Remarks = reader["Remarks"].ToString();


            return model;
        }

    }
}
