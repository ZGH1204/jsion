using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PlugIn.Core
{
    public class ExtensionPath
    {
        public string Name { get; private set; }
        public PlugIn PlugIn { get; private set; }
        public List<Codon> Codons { get; private set; }

        public ExtensionPath(string name, PlugIn plugIn)
        {
            Name = name;
            PlugIn = plugIn;

            Codons = new List<Codon>();
        }

        public static void ReadPath(System.Xml.XmlReader reader, Core.PlugIn plugIn)
        {
            if (reader.AttributeCount != 1) throw new Exception(PlugInConst.Path + " node requires only one attribute.");

            if (reader.IsEmptyElement) return;

            string name = reader.GetAttribute(0);

            ExtensionPath path = new ExtensionPath(name, plugIn);

            plugIn.Paths.Add(path.Name, path);

            while (reader.Read())
            {
                switch (reader.NodeType)
                {
                    case System.Xml.XmlNodeType.Element:
                        string elementName = reader.LocalName;

                        Codon newCodon = new Codon(path.PlugIn, elementName, Properties.ReadFromAttributes(reader));

                        path.Codons.Add(newCodon);

                        if (!reader.IsEmptyElement)
                        {
                            ReadPath(reader, plugIn);
                        }

                        break;
                    case System.Xml.XmlNodeType.EndElement:
                        if (reader.LocalName == PlugInConst.Path) return;
                        break;
                    default:
                        break;
                }
            }
        }
    }
}
