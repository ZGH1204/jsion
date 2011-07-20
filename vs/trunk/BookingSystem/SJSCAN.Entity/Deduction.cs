using System;
using System.Collections.Generic;
using System.Text;



namespace SJSCAN.Entity
{
    public partial class Deduction
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

        private string _Deductionname;
        /// <summary>
        /// 
        /// </summary>
        public string Deductionname
        {
            get { return _Deductionname; }
            set { _Deductionname = value.Trim(); }
        }

        private double _Deductionvalue;
        /// <summary>
        /// 
        /// </summary>
        public double Deductionvalue
        {
            get { return _Deductionvalue; }
            set { _Deductionvalue = value; }
        }

        private int _Deductioncount;
        /// <summary>
        /// 
        /// </summary>
        public int Deductioncount
        {
            get { return _Deductioncount; }
            set { _Deductioncount = value; }
        }

        private double _Deductionbalance;
        /// <summary>
        /// 
        /// </summary>
        public double Deductionbalance
        {
            get { return _Deductionbalance; }
            set { _Deductionbalance = value; }
        }

        private DateTime _Deductiontime;
        /// <summary>
        /// 
        /// </summary>
        public DateTime Deductiontime
        {
            get { return _Deductiontime; }
            set { _Deductiontime = value; }
        }

        private string _Remarks;
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
