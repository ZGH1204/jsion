using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PlugIn.Core
{
    public class Codon
    {
        public PlugIn PlugIn { get; private set; }

        public string Name { get; private set; }

        public Properties Properties { get; private set; }

        public string ID { get { return Properties["id"]; } }

        public string this[string key] { get { return Properties[key]; } }
        
        public Codon(PlugIn plugIn, string name, Properties properties)
        {
            PlugIn = plugIn;

            Name = name;

            Properties = properties;
        }

        internal object BuildItem(object caller, System.Collections.ArrayList subItems)
        {
            IDoozer doozer;

            if (!PlugInTree.Doozers.TryGetValue(Name, out doozer))
            {
                throw new Exception("Doozer " + Name + " not found!" + ToString());
            }

            return doozer.BuildItem(caller, this, subItems);
        }

        public override string ToString()
        {
            return String.Format("[Codon: name = {0}, id = {1}, plugInFile={2}]",
                                 Name,
                                 ID,
                                 PlugIn.PlugInFile);
        }
    }
}
