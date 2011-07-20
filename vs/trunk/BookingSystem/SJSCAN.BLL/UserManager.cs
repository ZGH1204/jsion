using System;
using System.Collections.Generic;
using System.Text;

using SJSCAN.Entity;
using Sjs.Data;
using System.Data;
using System.Data.Common;

namespace SJSCAN.BLL
{
    public partial class UserManager
    {
        /// <summary>
        /// 添加方法
        /// </summary>
        public static int AddUser(User user)
        {
            return DatabaseProvider.GetInstance().AddUser(user);
        }

        public static int AddUser(User user, DbTransaction trans)
        {
            return DatabaseProvider.GetInstance().AddUser(user, trans);
        }

        /// <summary>
        /// 删除方法
        /// </summary>
        public static int DelUser(int id)
        {
            return DatabaseProvider.GetInstance().DelUser(id);
        }

        /// <summary>
        /// 修改方法
        /// </summary>
        public static int UpdateUser(User user)
        {
            return DatabaseProvider.GetInstance().UpdateUser(user);
        }

        public static int UpdateUser(int uid, double balance)
        {
            return DatabaseProvider.GetInstance().UpdateUser(uid, balance);
        }

        public static int UpdateUser(int uid, double balance, DbTransaction trans)
        {
            return DatabaseProvider.GetInstance().UpdateUser(uid, balance, trans);
        }

        public static int UpdateUserBalance(int uid, double tradevalue)
        {
            return DatabaseProvider.GetInstance().UpdateUserBalance(uid, tradevalue);
        }

        public static int UpdateUserBalance(int uid, double tradevalue, DbTransaction trans)
        {
            return DatabaseProvider.GetInstance().UpdateUserBalance(uid, tradevalue, trans);
        }

        public static User GetUser(int id)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetUser(id);

            User model = null;

            if(reader.Read())
            {
                model = GetUser(reader);
            }

            reader.Close();
            return model;
        }

        public static User GetUser(int id, DbTransaction trans)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetUser(id, trans);

            User model = null;

            if(reader.Read())
            {
                model = GetUser(reader);
            }

            reader.Close();
            return model;
        }

        public static IList<User> GetUser(  )
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetUser( );

            IList<User> list = new List<User>();

            while(reader.Read())
            {
                User model = GetUser(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static IList<User> GetUser(int pageSize, int  currentPage)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetUser(pageSize, currentPage);

            IList<User> list = new List<User>();

            while(reader.Read())
            {
                User model = GetUser(reader);

                list.Add(model);
            }

            reader.Close();
            return list;
        }

        public static User GetUser(IDataReader reader)
        {
            User model = new User();

            model.Uid = (reader["Uid"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Uid"]));
            model.Account = reader["Account"].ToString();
            model.Passwd = reader["Passwd"].ToString();
            model.Realname = reader["Realname"].ToString();
            model.Balance = (reader["Balance"] is DBNull ? Convert.ToDouble("0") : Convert.ToDouble(reader["Balance"]));
            model.Enabled = (reader["Enabled"] is DBNull ? Convert.ToBoolean("false") : Convert.ToBoolean(reader["Enabled"]));
            model.Type = (reader["Type"] is DBNull ? Convert.ToInt32("0") : Convert.ToInt32(reader["Type"]));


            return model;
        }




        public static User GetUser(string account)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetUser(account);

            User model = null;

            if (reader.Read())
            {
                model = GetUser(reader);
            }

            reader.Close();
            return model;
        }

        public static User GetUser(string account, string passwd)
        {
            IDataReader reader = DatabaseProvider.GetInstance().GetUser(account, passwd);

            User model = null;

            if (reader.Read())
            {
                model = GetUser(reader);
            }

            reader.Close();
            return model;
        }

        public static int DisableUser(int uid, bool disable)
        {
            return DatabaseProvider.GetInstance().DisableUser(uid, disable);
        }
    }
}
