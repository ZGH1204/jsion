using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PlugIn.Core
{
    public class PropertyChangedEventArgs : EventArgs
    {
        public Properties Properties { get; private set; }

        public string Key { get; private set; }

        public object OldValue { get; private set; }

        public object NewValue { get; private set; }
        
        public PropertyChangedEventArgs(Properties properties, string key, object oldValue, object newValue)
        {
            Properties = properties;

            Key = key;

            OldValue = oldValue;

            NewValue = newValue;
        }
    }
}
