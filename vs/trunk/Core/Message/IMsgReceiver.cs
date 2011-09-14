using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Message
{
    public interface IMsgReceiver
    {
        string ID { get; }

        bool AllowReceiveMsg(uint msg);

        object ReceiveSync(Message msg);

        void ReceiveAsync(Message msg);
    }
}
