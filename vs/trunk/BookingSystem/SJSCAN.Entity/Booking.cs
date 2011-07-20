using System;
using System.Collections.Generic;
using System.Text;



namespace SJSCAN.Entity
{
    public partial class Booking
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

        private string _Bookingname;
        /// <summary>
        /// 
        /// </summary>
        public string Bookingname
        {
            get { return _Bookingname; }
            set { _Bookingname = value.Trim(); }
        }

        private DateTime _Bookingtime;
        /// <summary>
        /// 
        /// </summary>
        public DateTime Bookingtime
        {
            get { return _Bookingtime; }
            set { _Bookingtime = value; }
        }

        private bool _Isbooking;
        /// <summary>
        /// 
        /// </summary>
        public bool Isbooking
        {
            get { return _Isbooking; }
            set { _Isbooking = value; }
        }

        private bool _Issettle;
        public bool Issettle
        {
            get { return _Issettle; }
            set { _Issettle = value; }
        }

        private bool _Haserror;
        public bool Haserror
        {
            get { return _Haserror; }
            set { _Haserror = value; }
        }

    }
}
