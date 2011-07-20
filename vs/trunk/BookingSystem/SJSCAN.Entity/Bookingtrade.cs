using System;
using System.Collections.Generic;
using System.Text;



namespace SJSCAN.Entity
{
    public partial class Bookingtrade
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

        private int _Bookingshopid;
        /// <summary>
        /// 
        /// </summary>
        public int Bookingshopid
        {
            get { return _Bookingshopid; }
            set { _Bookingshopid = value; }
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

        private int _Handlerid;
        /// <summary>
        /// 
        /// </summary>
        public int Handlerid
        {
            get { return _Handlerid; }
            set { _Handlerid = value; }
        }

        private string _Handlername;
        /// <summary>
        /// 
        /// </summary>
        public string Handlername
        {
            get { return _Handlername; }
            set { _Handlername = value.Trim(); }
        }

        private int _Proxyid = 0;
        /// <summary>
        /// 
        /// </summary>
        public int Proxyid
        {
            get { return _Proxyid; }
            set { _Proxyid = value; }
        }

        private string _Proxyname = "";
        /// <summary>
        /// 
        /// </summary>
        public string Proxyname
        {
            get { return _Proxyname; }
            set { _Proxyname = value.Trim(); }
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

        private int _Tradeid;
        /// <summary>
        /// 
        /// </summary>
        public int Tradeid
        {
            get { return _Tradeid; }
            set { _Tradeid = value; }
        }

        private string _Tradename;
        /// <summary>
        /// 
        /// </summary>
        public string Tradename
        {
            get { return _Tradename; }
            set { _Tradename = value.Trim(); }
        }

        private double _Tradevalue;
        /// <summary>
        /// 
        /// </summary>
        public double Tradevalue
        {
            get { return _Tradevalue; }
            set { _Tradevalue = value; }
        }

        private int _Tradecount;
        /// <summary>
        /// 
        /// </summary>
        public int Tradecount
        {
            get { return _Tradecount; }
            set { _Tradecount = value; }
        }

        private bool _Issettle;
        /// <summary>
        /// 
        /// </summary>
        public bool Issettle
        {
            get { return _Issettle; }
            set { _Issettle = value; }
        }

        private DateTime _Bookinttime;
        /// <summary>
        /// 
        /// </summary>
        public DateTime Bookinttime
        {
            get { return _Bookinttime; }
            set { _Bookinttime = value; }
        }

        private string _Remarks = "";
        /// <summary>
        /// 
        /// </summary>
        public string Remarks
        {
            get { return _Remarks; }
            set { _Remarks = value.Trim(); }
        }
    }
}
