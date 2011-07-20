using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PlugIn.Core.DefaultDoozers
{
    public class ClassDoozer : IDoozer
    {
        public object BuildItem(object caller, Codon codon, System.Collections.ArrayList subItems)
        {
            return codon.PlugIn.CreateObject(codon.Properties["class"]);
        }
    }
}
