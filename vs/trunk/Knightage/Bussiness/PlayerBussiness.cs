using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Datas;
using System.Data.SqlClient;
using log4net;
using System.Reflection;

namespace Bussiness
{
    public class PlayerBussiness : BaseBussiness
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public uint GetID(string account)
        {
            SqlDataReader reader = null;

            try
            {
                SqlParameter[] paras = new SqlParameter[1];

                paras[0] = new SqlParameter("@account", account);

                db.GetReader(ref reader, "UP_Players_GetID", paras);

                if (reader != null && reader.Read())
                {
                    return Convert.ToUInt32(reader["playerid"]);
                }
            }
            catch (Exception ex)
            {
                log.Error("PlayerBussiness.GetID(string)", ex);
            }
            finally
            {
                if (reader != null && !reader.IsClosed)
                {
                    reader.Close();
                }
            }

            return 0;
        }
    }
}
