using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JsionFramework.Jsion.Attributes
{
    [AttributeUsage(AttributeTargets.Class, AllowMultiple = false, Inherited = false)]
    public class CommandAttribute : Attribute
    {
        private string m_cmd;
        private string m_description;
        private string m_usage;

        public CommandAttribute(string cmd, string description, string usage)
        {
            m_cmd = cmd;
            m_description = description;
            m_usage = usage;
        }


        public string Cmd
        {
            get { return m_cmd; }
        }

        public string Description
        {
            get { return m_description; }
        }

        public string Usage
        {
            get { return m_usage; }
        }
    }
}
