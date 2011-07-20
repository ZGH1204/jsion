using System;
using System.Collections.Generic;
using System.Text;

using SJSCAN.Entity;
using Sjs.Data;
using System.Data;
using System.Data.Common;

namespace SJSCAN.BLL
{
    public partial class TradeManager
    {
        /// <summary>
        /// 添加方法
        /// </summary>
        public static int AddTrade(Trade trade)
        {
            return DatabaseProvider.GetInstance().AddTrade(trade);
        }

        public static int AddTrade(Trade trade, DbTransaction trans)
        {
            return DatabaseProvider.GetInstance().AddTrade(trade, trans);
        }

        /// <summary>
        /// 删除方法
        /// </summary>
        public static int DelTrade(int id)
        {
            return DatabaseProvider.GetInstance().DelTrade(id);
        }

        public static int DelTrade(int id, DbTransaction trans)
        {
            return DatabaseProvider.GetInstance().DelTrade(id, trans);
        }

        /// <summary>
        /// 修改方法
        /// </summary>
        public static int UpdateTrade(Trade trade)
        {
            return DatabaseProvider.GetInstance().UpdateTrade(trade);
        }

        public static Trade GetTrade(int id)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetTrade(id);

            Trade model = null;

            if(reader.Read())
            {
                model = GetTrade(reader);
            }

            reader.Close();
            return model;
        }

        public static IList<Trade> GetTrade(  )
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetTrade( );

            IList<Trade> list = new List<Trade>();

            while(reader.Read())
            {
                Trade model = GetTrade(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static IList<Trade> GetTrade(int shopid, bool notUseThisParam)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetTrade(shopid, notUseThisParam);

            IList<Trade> list = new List<Trade>();

            while(reader.Read())
            {
                Trade model = GetTrade(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static IList<Trade> GetTrade(int pageSize, int  currentPage)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetTrade(pageSize, currentPage);

            IList<Trade> list = new List<Trade>();

            while(reader.Read())
            {
                Trade model = GetTrade(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static Trade GetTrade(IDataReader reader)
        {
            Trade model = new Trade();

            model.Id = (reader["Id"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Id"]));
            model.Shopid = (reader["Shopid"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Shopid"]));
            model.Tradename = reader["Tradename"].ToString();
            model.Tradevalue = (reader["Tradevalue"] is DBNull ? Convert.ToDouble("0") : Convert.ToDouble(reader["Tradevalue"]));


            return model;
        }
    }
}
