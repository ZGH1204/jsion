using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Message
{
    public class Message
    {
        /// <summary>
        /// 发送者
        /// </summary>
        public string Sender { get; set; }

        /// <summary>
        /// 接收者列表
        /// </summary>
        public string[] Receivers { get; set; }

        /// <summary>
        /// 消息标识
        /// </summary>
        public uint Msg { get; set; }

        /// <summary>
        /// 消息参数
        /// </summary>
        public object WParam { get; set; }

        /// <summary>
        /// 消息参数
        /// </summary>
        public object LParam { get; set; }

        /// <summary>
        /// 消息发送时刻 Environment.TickCount
        /// </summary>
        public int tick { get; set; }
    }
}
