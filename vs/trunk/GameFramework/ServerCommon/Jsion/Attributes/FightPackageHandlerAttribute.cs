using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ServerCommon.Jsion.Attributes
{
    [AttributeUsage(AttributeTargets.Class, AllowMultiple = false, Inherited = false)]
    public class FightPackageHandlerAttribute : Attribute
    {
        protected int m_code;
        protected string m_dscpt;

        public FightPackageHandlerAttribute(int code, string dscpt)
        {
            m_code = code;
            m_dscpt = dscpt;
        }

        public int Code
        {
            get { return m_code; }
        }

        public string Description
        {
            get { return m_dscpt; }
        }
    }
}
