using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Reflection;

namespace Tools
{
    public class DB2CSUtil
    {
        public const string CONVERT_TEMPLATE = "info.{0} = Convert.To{1}(reader[\"{0}\"]);";

        public static void Reader2Entity(IDataReader reader, Type type)
        {
            StringBuilder sb = new StringBuilder();

            for (int i = 0; i < reader.FieldCount; i++)
            {
                string name = reader.GetName(i);
                
                PropertyInfo pi = type.GetProperty(name);
                
                if (pi != null)
                {
                }
            }
        }
    }
}
