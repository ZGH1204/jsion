using System;
using System.Collections.Generic;
using System.Text;



namespace SJSCAN.Entity
{
    public partial class App
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

        private bool _Isinstall;
        /// <summary>
        /// 
        /// </summary>
        public bool Isinstall
        {
            get { return _Isinstall; }
            set { _Isinstall = value; }
        }



    }
}
