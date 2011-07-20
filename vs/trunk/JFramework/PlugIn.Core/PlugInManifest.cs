using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;

namespace PlugIn.Core
{
    public class PlugInManifest
    {
        public List<PlugInReference> Conflicts { get; private set; }
        public List<PlugInReference> Dependencies { get; private set; }
        public Dictionary<string, Version> Identities { get; private set; }

        public Version PrimaryVersion { get; private set; }

        public string PrimaryIdentity { get; private set; }

        public PlugInManifest()
        {
            Conflicts = new List<PlugInReference>();
            Dependencies = new List<PlugInReference>();
            Identities = new Dictionary<string, Version>();
        }

        public void ReadManifest(XmlReader reader, PlugIn plugIn)
        {
            if (reader.AttributeCount != 0)
            {
                throw new Exception(PlugInConst.Manifest + " node cannot have attributes.");
            }
            if (reader.IsEmptyElement)
            {
                throw new Exception(PlugInConst.Manifest + " node cannot be empty.");
            }

            while (reader.Read())
            {
                switch (reader.NodeType)
                {
                    case XmlNodeType.Element:
                        string nodeName = reader.LocalName;
                        Properties properties = Properties.ReadFromAttributes(reader);
                        switch (nodeName)
                        {
                            case PlugInConst.ManifestIdentity:
                                AddIdentity(properties["name"], properties["version"], plugIn.PlugInDir);
                                break;
                            case PlugInConst.ManifestDependency:
                                Dependencies.Add(PlugInReference.Create(properties, plugIn.PlugInDir));
                                break;
                            case PlugInConst.ManifestConflict:
                                Conflicts.Add(PlugInReference.Create(properties, plugIn.PlugInDir));
                                break;
                            default:
                                throw new Exception("Unknown node in " + PlugInConst.Manifest + " section:" + nodeName + " plugIn:" + plugIn.PlugInFile);
	                    }
                        break;
                    case XmlNodeType.EndElement:
                        if (reader.LocalName == PlugInConst.Manifest) return;
                        break;
                    default:
                        break;
                }
            }
        }

        private void AddIdentity(string name, string version, string hintPath)
        {
            if (name.IsNullOrEmpty()) throw new ArgumentNullException("name");

            foreach (char c in name)
            {
                if (!char.IsLetterOrDigit(c) && c != '.' && c != '_')
                {
                    throw new Exception(PlugInConst.ManifestIdentity + " name contains invalid character: '" + c + "'");
                }
            }
            Version v = PlugInReference.ParseVersion(version, hintPath);
            if (PrimaryVersion == null)
            {
                PrimaryVersion = v;
            }
            if (PrimaryIdentity == null)
            {
                PrimaryIdentity = name;
            }

            Identities.Add(name, v);
        }
    }
}
