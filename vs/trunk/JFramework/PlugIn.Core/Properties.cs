using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Globalization;
using System.Xml;

namespace PlugIn.Core
{
    public class Properties
    {
        public delegate void PropertyChangedEventHandler(object sender, PropertyChangedEventArgs e);

        Dictionary<string, object> properties = new Dictionary<string, object>();

        public event PropertyChangedEventHandler PropertyChanged;

        public string this[string property]
        {
            get
            {
                lock (properties)
                {
                    object val;
                    properties.TryGetValue(property, out val);
                    return Convert.ToString(val, CultureInfo.InvariantCulture);
                }
            }
            set
            {
                if (property.IsNullOrEmpty())
                {
                    throw new ArgumentNullException("property");
                }

                if (value == null)
                {
                    throw new ArgumentNullException("Properties's" + property + "：value");
                }

                string oldValue = null;

                lock (properties)
                {
                    if (properties.ContainsKey(property))
                    {
                        oldValue = Convert.ToString(properties[property], CultureInfo.InvariantCulture);
                    }

                    properties[property] = value;
                }

                OnPropertyChanged(new PropertyChangedEventArgs(this, property, oldValue, value));
            }
        }

        public string[] Elements
        {
            get
            {
                lock (properties)
                {
                    List<string> ret = new List<string>();
                    foreach (KeyValuePair<string, object> property in properties)
                        ret.Add(property.Key);
                    return ret.ToArray();
                }
            }
        }

        public bool Contains(string property)
        {
            lock (properties)
            {
                return properties.ContainsKey(property);
            }
        }

        public int Count
        {
            get
            {
                lock (properties)
                {
                    return properties.Count;
                }
            }
        }

        public bool Remove(string property)
        {
            lock (properties)
            {
                return properties.Remove(property);
            }
        }

        protected virtual void OnPropertyChanged(PropertyChangedEventArgs e)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, e);
            }
        }

        public override string ToString()
        {
            lock (properties)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("[Properties:{");
                foreach (KeyValuePair<string, object> entry in properties)
                {
                    sb.Append(entry.Key);
                    sb.Append("=");
                    sb.Append(entry.Value);
                    sb.Append(",");
                }
                sb.Append("}]");
                return sb.ToString();
            }
        }

        public static Properties ReadFromAttributes(XmlReader reader)
        {
            Properties properties = new Properties();
            if (reader.HasAttributes)
            {
                for (int i = 0; i < reader.AttributeCount; i++)
                {
                    reader.MoveToAttribute(i);
                    properties[reader.Name] = reader.Value;
                }
                reader.MoveToElement(); //Moves the reader back to the element node.
            }
            return properties;
        }
    }
}
