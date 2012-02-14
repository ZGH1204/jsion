using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GameBase.Packets
{
    [AttributeUsage(AttributeTargets.Class, AllowMultiple = false, Inherited = false)]
    public class PacketHandlerAttribute : Attribute
    {
        public int Code { get; protected set; }

        public string Description { get; protected set; }

        public PacketHandlerAttribute(int code, string description = "")
        {
            Code = code;

            Description = description;
        }
    }
}
