using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Message
{
    [AttributeUsage(AttributeTargets.Method, AllowMultiple = false, Inherited = true)]
    public class MsgHandlerAttribute : Attribute
    {
        public uint Msg { get; protected set; }
        public bool SubscibeHandler { get; protected set; }
        public string Description { get; protected set; }

        public MsgHandlerAttribute(uint msg, bool subscibeHandler, string description)
        {
            Msg = msg;
            SubscibeHandler = subscibeHandler;
            Description = description;
        }
    }
}
