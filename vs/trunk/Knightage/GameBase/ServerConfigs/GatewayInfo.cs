using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;

namespace GameBase.ServerConfigs
{
    [Serializable]
    public class GatewayInfo : Template
    {
        [XmlAttribute]
        public string IP { get; set; }

        [XmlAttribute]
        public int Port { get; set; }

        [XmlIgnore]
        public bool Fulled { get; set; }

        [XmlAttribute]
        public string Summary { get; set; }
    }
}
