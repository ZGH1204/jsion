using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;

namespace JUtils.Messages
{
    public class JMethodInfo
    {
        public object Scope { get; protected set; }

        public MethodInfo Method { get; protected set; }

        public JMethodInfo(object scope, MethodInfo method)
        {
            Scope = scope;
            Method = method;
        }

        public object Invoke(object[] parameters, object scope = null)
        {
            if (scope == null)
            {
                return Method.Invoke(Scope, parameters);
            }
            else
            {
                return Method.Invoke(scope, parameters);
            }
        }
    }
}
