using System;
using System.Collections.Generic;
using System.Text;



namespace SJSCAN.Entity
{
    public partial class Balance
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

        private double _Balances;
        /// <summary>
        /// 
        /// </summary>
        public double Balances
        {
            get { return _Balances; }
            set { _Balances = value; }
        }

        private DateTime _Btime;
        /// <summary>
        /// 
        /// </summary>
        public DateTime Btime
        {
            get { return _Btime; }
            set { _Btime = value; }
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
