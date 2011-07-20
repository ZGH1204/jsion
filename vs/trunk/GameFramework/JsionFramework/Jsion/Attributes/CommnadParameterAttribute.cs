using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JsionFramework.Jsion.Attributes
{
    [AttributeUsage(AttributeTargets.Class, AllowMultiple = true, Inherited = false)]
    public class CommandParameterAttribute : Attribute
    {
        private string m_key;
        private string m_description;

        public CommandParameterAttribute(string paramKey, string paramDescription)
        {
            m_key = paramKey;
            m_description = paramDescription;
        }

        public string Key
        {
            get { return m_key; }
        }

        public string Description
        {
            get { return m_description; }
        }
    }
}
