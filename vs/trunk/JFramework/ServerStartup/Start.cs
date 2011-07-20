using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using PlugIn.Core;

namespace ServerStartup
{
    public class Start : IDoozer
    {
        public object BuildItem(object caller, Codon codon, System.Collections.ArrayList subItems)
        {
            ServerStartup server = new ServerStartup();

            server.Startup();

            return server;
        }
    }
}
