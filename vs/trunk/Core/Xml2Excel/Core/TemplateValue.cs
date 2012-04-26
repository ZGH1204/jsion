using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Xml2Excel.Core
{
    public class TemplateValue
    {
        public string NodeName { get; set; }

        public Dictionary<string, string> Props { get; set; }
    }
}
