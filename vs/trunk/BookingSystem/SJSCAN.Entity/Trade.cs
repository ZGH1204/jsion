using System;
using System.Collections.Generic;
using System.Text;



namespace SJSCAN.Entity
{
    public partial class Trade
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

        private int _Shopid;
        /// <summary>
        /// 
        /// </summary>
        public int Shopid
        {
            get { return _Shopid; }
            set { _Shopid = value; }
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



    }
}
