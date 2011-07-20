using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using PlugIn.Core;
using JUtils.Messages;

namespace NetWork
{
    public class ListenerDoozer : IDoozer
    {
        public object BuildItem(object caller, Codon codon, System.Collections.ArrayList subItems)
        {
            IMsgReceiver receiver = MsgMonitor.GetReceiver(codon.ID);

            if (receiver == null)
            {
                receiver = new GameListener(codon.ID);
            }

            return receiver;
        }
    }
}
