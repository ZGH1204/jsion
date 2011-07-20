using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PlugIn.Core.DefaultDoozers
{
    public class StringDoozer : IDoozer
    {
        public object BuildItem(object caller, Codon codon, System.Collections.ArrayList subItems)
        {
            return codon.Properties["text"];
        }
    }
}
