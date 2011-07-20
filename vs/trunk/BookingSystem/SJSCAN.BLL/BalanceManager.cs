using System;
using System.Collections.Generic;
using System.Text;

using SJSCAN.Entity;
using Sjs.Data;
using System.Data;

namespace SJSCAN.BLL
{
    public partial class BalanceManager
    {
        /// <summary>
        /// 添加方法
        /// </summary>
        public static int AddBalance(Balance balance)
        {
            return DatabaseProvider.GetInstance().AddBalance(balance);
        }

        public static int AddBalance(Balance balances, System.Data.Common.DbTransaction trans)
        {
            return DatabaseProvider.GetInstance().AddBalance(balances, trans);
        }

        /// <summary>
        /// 删除方法
        /// </summary>
        public static int DelBalance(int id)
        {
            return DatabaseProvider.GetInstance().DelBalance(id);
        }

        /// <summary>
        /// 修改方法
        /// </summary>
        public static int UpdateBalance(Balance balance)
        {
            return DatabaseProvider.GetInstance().UpdateBalance(balance);
        }

        public static Balance GetBalance(int id)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBalance(id);

            Balance model = null;

            if(reader.Read())
            {
                model = GetBalance(reader);
            }

            reader.Close();
            return model;
        }

        public static IList<Balance> GetBalance(  )
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBalance( );

            IList<Balance> list = new List<Balance>();

            while(reader.Read())
            {
                Balance model = GetBalance(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <param name="notUseThisParam">未用到,可传任意值.</param>
        /// <returns></returns>
        public static IList<Balance> GetBalance(int id, bool notUseThisParam)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBalance(id, notUseThisParam);

            IList<Balance> list = new List<Balance>();

            while(reader.Read())
            {
                Balance model = GetBalance(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static IList<Balance> GetBalance(int pageSize, int  currentPage)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetBalance(pageSize, currentPage);

            IList<Balance> list = new List<Balance>();

            while(reader.Read())
            {
                Balance model = GetBalance(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static Balance GetBalance(IDataReader reader)
        {
            Balance model = new Balance();

            model.Id = (reader["Id"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Id"]));
            model.Uid = (reader["Uid"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Uid"]));
            model.Balances = (reader["Balances"] is DBNull ? Convert.ToDouble("0") : Convert.ToDouble(reader["Balances"]));
            model.Btime = (reader["Btime"] is DBNull ? Convert.ToDateTime("1900-01-01") : Convert.ToDateTime(reader["Btime"]));
            model.Remarks = reader["Remarks"].ToString();


            return model;
        }

    }
}
