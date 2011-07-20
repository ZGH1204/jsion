using System;
using System.Collections.Generic;
using System.Text;



namespace SJSCAN.Entity
{
    public partial class Bookingshop
    {
        private int _Id;
        /// <summary>
        /// 
        /// </summary>
        public int Id
        {
            get { return _Id; }
            set { _Id = value; }
        }

        private int _Bookingid;
        /// <summary>
        /// 
        /// </summary>
        public int Bookingid
        {
            get { return _Bookingid; }
            set { _Bookingid = value; }
        }

        private string _Bookingname;
        /// <summary>
        /// 
        /// </summary>
        public string Bookingname
        {
            get { return _Bookingname; }
            set { _Bookingname = value.Trim(); }
        }

        private int _Uid;
        /// <summary>
        /// 
        /// </summary>
        public int Uid
        {
            get { return _Uid; }
            set { _Uid = value; }
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

        private int _Shopid;
        /// <summary>
        /// 
        /// </summary>
        public int Shopid
        {
            get { return _Shopid; }
            set { _Shopid = value; }
        }

        private string _Shopname;
        /// <summary>
        /// 
        /// </summary>
        public string Shopname
        {
            get { return _Shopname; }
            set { _Shopname = value.Trim(); }
        }

        private DateTime _Begintime;
        /// <summary>
        /// 
        /// </summary>
        public DateTime Begintime
        {
            get { return _Begintime; }
            set { _Begintime = value; }
        }

        private bool _Isover;
        /// <summary>
        /// 
        /// </summary>
        public bool Isover
        {
            get { return _Isover; }
            set { _Isover = value; }
        }



    }
}
