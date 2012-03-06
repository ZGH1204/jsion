using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DBProvider;
using log4net;
using System.Reflection;

namespace Bussiness
{
    public class BaseBussiness : IDisposable
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected Sql_DbObject db;

        public BaseBussiness()
        {
            db = new Sql_DbObject("AppConfig", "connectString");
        }

        public void Dispose()
        {
            db.Dispose();
            GC.SuppressFinalize(this);
        }
    }
}
