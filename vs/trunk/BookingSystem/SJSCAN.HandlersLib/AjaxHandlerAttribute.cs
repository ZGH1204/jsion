using System;
using System.Collections.Generic;
using System.Text;

namespace SJSCAN.HandlersLib
{
    [AttributeUsage(AttributeTargets.Class, AllowMultiple = true, Inherited = true)]
    internal class AjaxHandlerAttribute : Attribute
    {
        private string _method;

        public string Method
        {
            get
            {
                return _method;
            }
        }

        private string _description;

        public string Description
        {
            get
            {
                return _description;
            }
        }

        public AjaxHandlerAttribute(string method, string description)
        {
            _method = method;
            _description = description;
        }
    }
}
