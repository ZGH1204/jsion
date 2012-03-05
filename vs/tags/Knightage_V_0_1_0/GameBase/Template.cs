using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;

namespace GameBase
{
    public class Template
    {
        /// <summary>
        /// 模板ID
        /// </summary>
        [XmlAttribute]
        public uint TemplateID { get; set; }

        /// <summary>
        /// 模板名称
        /// </summary>
        [XmlAttribute]
        public string TemplateName { get; set; }
    }
}
