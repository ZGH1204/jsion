using System;
using System.Text;

namespace Sjs.Common.Xml
{
    public class InvalidXmlException : SJSException
    {
        public InvalidXmlException(string message)
            : base(message)
        {
        }
    }
}
