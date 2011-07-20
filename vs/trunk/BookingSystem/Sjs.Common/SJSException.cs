using System;
using System.Collections.Generic;
using System.Text;

namespace Sjs.Common
{
    /// <summary>
    /// SJS自定义异常类
    /// </summary>
    public class SJSException : Exception
    {
        public SJSException()
        {
            //
        }

        public SJSException(string msg)
            : base(msg)
        {
            //
        }
    }
}
