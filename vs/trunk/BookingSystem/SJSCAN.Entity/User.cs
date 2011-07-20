using System;
using System.Collections.Generic;
using System.Text;

namespace SJSCAN.Entity
{
    public partial class User
    {
        private int _Uid;
        /// <summary>
        /// 
        /// </summary>
        public int Uid
        {
            get { return _Uid; }
            set { _Uid = value; }
        }

        private string _Account;
        /// <summary>
        /// 
        /// </summary>
        public string Account
        {
            get { return _Account; }
            set { _Account = value.Trim(); }
        }

        private string _Passwd;
        /// <summary>
        /// 
        /// </summary>
        public string Passwd
        {
            get { return _Passwd; }
            set { _Passwd = value.Trim(); }
        }

        private string _Realname;
        /// <summary>
        /// 
        /// </summary>
        public string Realname
        {
            get { return _Realname; }
            set { _Realname = value.Trim(); }
        }

        private double _Balance;
        /// <summary>
        /// 
        /// </summary>
        public double Balance
        {
            get { return _Balance; }
            set { _Balance = value; }
        }

        private bool _Enabled;
        /// <summary>
        /// 
        /// </summary>
        public bool Enabled
        {
            get { return _Enabled; }
            set { _Enabled = value; }
        }

        private int _Type;
        /// <summary>
        /// 
        /// </summary>
        public int Type
        {
            get { return _Type; }
            set { _Type = value; }
        }

        public bool IsAdmin
        {
            get
            {
                return User.IsAdministrator(_Type);
            }
        }

        public static bool IsAdministrator(int type)
        {
            return (type == (int)eAuthority.AdminUser);
        }
    }
}
