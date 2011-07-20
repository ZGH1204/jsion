using System;
using System.Collections.Generic;
using System.Text;



namespace SJSCAN.Entity
{
    public partial class Shop
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

        private string _Shopname;
        /// <summary>
        /// 
        /// </summary>
        public string Shopname
        {
            get { return _Shopname; }
            set { _Shopname = value.Trim(); }
        }

        private string _Phone;
        /// <summary>
        /// 
        /// </summary>
        public string Phone
        {
            get { return _Phone; }
            set { _Phone = value.Trim(); }
        }



    }
}
