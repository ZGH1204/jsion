using System;
using System.Text;

namespace Sjs.Data
{
    public class DbException:Sjs.Common.SJSException
    {
        public DbException(string message):base(message)
        { }

        private int _number = 0;

        public int Number
        {
            get { return _number; }
        }
    }
}
