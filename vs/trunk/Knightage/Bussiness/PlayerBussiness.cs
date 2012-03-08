using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Datas;
using System.Data.SqlClient;
using log4net;
using System.Reflection;
using System.Data;

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
                SqlParameter[] paras = {
                    new SqlParameter("@account", account)
                };

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

        public uint Registe(string account, string nickName)
        {
            try
            {
                SqlParameter[] paras = {
                    new SqlParameter("@playerid", ParameterDirection.Output),
                    new SqlParameter("@account", account),
                    new SqlParameter("@nickName", account)
                };

                db.RunProcedure("UP_Players_Add", paras);

                uint playerID = Convert.ToUInt32(paras[0].SqlValue);

                return playerID;
            }
            catch (Exception ex)
            {
                log.Error("PlayerBussiness.Registe(string, string)", ex);
            }

            return 0;
        }
    }
}
