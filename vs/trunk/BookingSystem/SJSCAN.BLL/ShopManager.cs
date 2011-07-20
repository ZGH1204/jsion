using System;
using System.Collections.Generic;
using System.Text;

using SJSCAN.Entity;
using Sjs.Data;
using System.Data;
using System.Data.Common;

namespace SJSCAN.BLL
{
    public partial class ShopManager
    {
        /// <summary>
        /// 添加方法
        /// </summary>
        public static int AddShop(Shop shop)
        {
            return DatabaseProvider.GetInstance().AddShop(shop);
        }

        public static int AddShop(Shop shop, DbTransaction trans)
        {
            return DatabaseProvider.GetInstance().AddShop(shop, trans);
        }

        /// <summary>
        /// 删除方法
        /// </summary>
        public static int DelShop(int id)
        {
            return DatabaseProvider.GetInstance().DelShop(id);
        }


        public static int DelShop(int id, System.Data.Common.DbTransaction trans)
        {
            return DatabaseProvider.GetInstance().DelShop(id, trans);
        }

        /// <summary>
        /// 修改方法
        /// </summary>
        public static int UpdateShop(Shop shop)
        {
            return DatabaseProvider.GetInstance().UpdateShop(shop);
        }

        public static Shop GetShop(int id)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetShop(id);

            Shop model = null;

            if(reader.Read())
            {
                model = GetShop(reader);
            }

            reader.Close();
            return model;
        }

        public static IList<Shop> GetShop(  )
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetShop( );

            IList<Shop> list = new List<Shop>();

            while(reader.Read())
            {
                Shop model = GetShop(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static IList<Shop> GetShop(int pageSize, int  currentPage)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetShop(pageSize, currentPage);

            IList<Shop> list = new List<Shop>();

            while(reader.Read())
            {
                Shop model = GetShop(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static Shop GetShop(IDataReader reader)
        {
            Shop model = new Shop();

            model.Id = (reader["Id"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Id"]));
            model.Shopname = reader["shopname"].ToString();
            model.Phone = reader["Phone"].ToString();


            return model;
        }
    }
}
