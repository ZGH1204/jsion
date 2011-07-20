using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JUtils.Attributes;
using System.Reflection;
using System.Configuration;
using log4net;

namespace JUtils
{
    public abstract class AppConfigAbstract
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected virtual void Load(Type type)
        {
            ConfigurationManager.RefreshSection("appSettings");
            FieldInfo[] fields = type.GetFields();
            foreach (FieldInfo field in fields)
            {
                object[] attributes = field.GetCustomAttributes(typeof(AppConfigAttribute), false);

                if (attributes.Length == 0) continue;

                AppConfigAttribute attribute = (AppConfigAttribute)attributes[0];

                field.SetValue(this, LoadConfigValue(attribute));
            }
        }

        private object LoadConfigValue(AppConfigAttribute attribute)
        {
            string key = attribute.Key;

            string val = ConfigurationManager.AppSettings[key];

            if (val == null)
            {
                val = attribute.DefaultValue.ToString();
                log.WarnFormat("Loading {0} value is null, using default value:'{1}'", key, val);
            }
            else
            {
                log.InfoFormat("Loading {0} value is '{1}'", key, val);
            }

            try
            {
                return Convert.ChangeType(val, attribute.DefaultValue.GetType());
            }
            catch (Exception ex)
            {
                log.Error("Exception in ServerConfig load: ", ex);
                return null;
            }
        }
    }
}
