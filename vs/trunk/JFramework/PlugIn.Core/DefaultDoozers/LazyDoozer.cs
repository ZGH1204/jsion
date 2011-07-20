using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PlugIn.Core.DefaultDoozers
{
    public class LazyDoozer : IDoozer
    {
        public PlugIn PlugIn { get; private set; }
        public Properties Properties { get; private set; }

        public string Name { get { return Properties["name"]; } }
        public string ClassName { get { return Properties["class"]; } }

        public LazyDoozer(PlugIn plugIn, Properties properties)
        {
            PlugIn = plugIn;
            Properties = properties;
        }

        public object BuildItem(object caller, Codon codon, System.Collections.ArrayList subItems)
        {
            IDoozer doozer;

            if (PlugInTree.Doozers.ContainsKey(Name))
            {
                if (PlugInTree.Doozers[Name] is LazyDoozer)
                {
                    doozer = PlugIn.CreateDoozer(ClassName);
                    if (doozer != null) PlugInTree.Doozers[Name] = doozer;
                    else return null;
                }
                doozer = PlugInTree.Doozers[Name];
            }
            else
            {
                doozer = PlugIn.CreateDoozer(ClassName);
                if (doozer != null) PlugInTree.Doozers[Name] = doozer;
                else return null;
            }

            return doozer.BuildItem(caller, codon, subItems);
        }
    }
}
