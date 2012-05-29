using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Xml2Excel.Core
{
    public class TemplateStruct
    {
        public string NodeName { get; set; }

        public string NodeType { get; set; }

        public List<string> Attributes { get; set; }

        public List<string> Types { get; set; }
    }
}
