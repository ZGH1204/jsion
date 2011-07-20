using System;
using System.Collections.Generic;
using System.Text;

using SJSCAN.Entity;
using Sjs.Data;
using System.Data;
using System.Data.Common;

namespace SJSCAN.BLL
{
    public partial class DeductionManager
    {
        /// <summary>
        /// 添加方法
        /// </summary>
        public static int AddDeduction(Deduction deduction)
        {
            return DatabaseProvider.GetInstance().AddDeduction(deduction);
        }

        public static int AddDeduction(Deduction deduction, DbTransaction trans)
        {
            return DatabaseProvider.GetInstance().AddDeduction(deduction, trans);
        }

        /// <summary>
        /// 删除方法
        /// </summary>
        public static int DelDeduction(int id)
        {
            return DatabaseProvider.GetInstance().DelDeduction(id);
        }

        /// <summary>
        /// 修改方法
        /// </summary>
        public static int UpdateDeduction(Deduction deduction)
        {
            return DatabaseProvider.GetInstance().UpdateDeduction(deduction);
        }

        public static Deduction GetDeduction(int id)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetDeduction(id);

            Deduction model = null;

            if(reader.Read())
            {
                model = GetDeduction(reader);
            }

            reader.Close();
            return model;
        }

        public static IList<Deduction> GetDeduction(  )
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetDeduction( );

            IList<Deduction> list = new List<Deduction>();

            while(reader.Read())
            {
                Deduction model = GetDeduction(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static IList<Deduction> GetDeduction(int pageSize, int  currentPage)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetDeduction(pageSize, currentPage);

            IList<Deduction> list = new List<Deduction>();

            while(reader.Read())
            {
                Deduction model = GetDeduction(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static Deduction GetDeduction(IDataReader reader)
        {
            Deduction model = new Deduction();

            model.Id = (reader["Id"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Id"]));
            model.Uid = (reader["Uid"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Uid"]));
            model.Realname = reader["Realname"].ToString();
            model.Shopid = (reader["Shopid"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Shopid"]));
            model.Shopname = reader["Shopname"].ToString();
            model.Deductionname = reader["Deductionname"].ToString();
            model.Deductionvalue = (reader["Deductionvalue"] is DBNull ? Convert.ToDouble("0") : Convert.ToDouble(reader["Deductionvalue"]));
            model.Deductioncount = (reader["Deductioncount"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Deductioncount"]));
            model.Deductionbalance = (reader["Deductionbalance"] is DBNull ? Convert.ToDouble("0") : Convert.ToDouble(reader["Deductionbalance"]));
            model.Deductiontime = (reader["Deductiontime"] is DBNull ? Convert.ToDateTime("1900-01-01") : Convert.ToDateTime(reader["Deductiontime"]));
            model.Remarks = reader["Remarks"].ToString();


            return model;
        }


        public static IList<Deduction> GetDeduction(int uid, bool unUsedThisParam)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetDeduction(uid, unUsedThisParam);

            IList<Deduction> list = new List<Deduction>();

            while (reader.Read())
            {
                Deduction model = GetDeduction(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static int GetDeductionCount(int uid)
        {
            return DatabaseProvider.GetInstance().GetDeductionCount(uid);
        }

        public static IList<Deduction> GetDeduction(int uid, int pageSize, int currentPage)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetDeduction(uid, pageSize, currentPage);

            IList<Deduction> list = new List<Deduction>();

            while (reader.Read())
            {
                Deduction model = GetDeduction(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }
    }
}
