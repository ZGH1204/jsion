using System;
using System.Collections.Generic;
using System.Text;
using System.Data.Common;
using System.Data;

namespace Sjs.Data.SqlServer
{
    public partial class DataProvider : IDataProvider
    {
        public int GetRecordCount(string tablename, string strwhere)
        {
            if (string.IsNullOrEmpty(tablename))
            {
                return -1;
            }

            string cmdText = "SELECT COUNT(id) FROM " + tablename + (string.IsNullOrEmpty(strwhere) ? "" : " WHERE " + strwhere);

            return int.Parse(DbHelper.ExecuteScalar(CommandType.Text, cmdText).ToString());
        }

        public int GetRecordCount(string tablename)
        {
            return GetRecordCount(tablename, "");
        }
        public IDataReader GetListByPage(int pageSize, int currentPage, string tab1, string tab2, string strWhere, string byPage, string relateCol)
        {
            if (string.IsNullOrEmpty(tab1))
            {
                throw new ArgumentNullException("tab1");
            }
            if (string.IsNullOrEmpty(byPage))
            {
                throw new ArgumentNullException("byPage");
            }
            if (pageSize <= 0)
            {
                pageSize = 10;
            }
            if (currentPage <= 0)
            {
                currentPage = 1;
            }

            int pagetop = (currentPage - 1) * pageSize;

            DbParameter[] cmdParameters ={ DbHelper.MakeInParam("@id", (DbType)SqlDbType.Int, 0, 0) };

            string cmdText = "";

            string where1 = "", where2 = "";

            if (!string.IsNullOrEmpty(strWhere))
            {
                where1 = " WHERE " + strWhere;
                where2 = " AND " + strWhere;
            }

            if (string.IsNullOrEmpty(tab2))
            {
                if (currentPage == 1)
                {
                    cmdText = string.Format("SELECT TOP {0} * FROM " + tab1 + where1, pageSize.ToString());
                }
                else
                {
                    cmdText = string.Format("SELECT TOP {0} * FROM " + tab1 + " WHERE " + byPage + "<(SELECT MIN(" + byPage + ") FROM (SELECT TOP {1} " + byPage + " FROM " + tab1 + where1 + " ORDER BY " + byPage + " DESC) AS tblTemp)" + where2 + " ORDER BY " + byPage + " DESC", pageSize.ToString(), pagetop.ToString());
                }
            }
            else
            {
                if (currentPage == 1)
                {
                    cmdText = string.Format("SELECT TOP {0} a.id AS aid,b.id AS bid,a.*,b.* FROM " + tab1 + " AS a LEFT JOIN " + tab2 + " AS b ON " + relateCol + where1, pageSize.ToString());
                }
                else
                {
                    cmdText = string.Format("SELECT TOP {0} a.id AS aid,b.id AS bid,a.*,b.* FROM " + tab1 + " AS a LEFT JOIN " + tab2 + " AS b ON " + relateCol + " WHERE a." + byPage + "<(SELECT MIN(" + byPage + ") FROM (SELECT TOP {1} " + byPage + " FROM " + tab1 + where1 + " ORDER BY " + byPage + " DESC) AS tblTemp)" + where2 + " ORDER BY a." + byPage + " DESC", pageSize.ToString(), pagetop.ToString());
                }
            }

            return DbHelper.ExecuteReader(CommandType.Text, cmdText, cmdParameters);
        }
    }
}
