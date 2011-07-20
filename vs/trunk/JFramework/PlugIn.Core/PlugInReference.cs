using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;
using System.IO;

namespace PlugIn.Core
{
    public class PlugInReference : ICloneable
    {
        public string Name { get; private set; }

        public bool RequirePreload { get; private set; }

        public Version MinimumVersion { get; private set; }

        public Version MaximumVersion { get; private set; }

        public PlugInReference(string name):this(name, new Version(0, 0, 0, 0), new Version(int.MaxValue, int.MaxValue)) { }

        public PlugInReference(string name, Version specialVersioin) : this(name, specialVersioin, specialVersioin) { }

        public PlugInReference(string name, Version minimumVersion, Version maximumVersion)
        {
            if (name.IsNullOrEmpty()) throw new ArgumentNullException("name");
            if (minimumVersion == null) throw new ArgumentNullException("minimumVersion");
            if (maximumVersion == null) throw new ArgumentNullException("maximumVersion");
            Name = name;
            MinimumVersion = minimumVersion;
            MaximumVersion = maximumVersion;
        }

        public override bool Equals(object obj)
        {
            if (!(obj is PlugInReference)) return false;
            PlugInReference b = (PlugInReference)obj;
            return Name == b.Name && MinimumVersion == b.MinimumVersion && MaximumVersion == b.MaximumVersion;
        }

        public override int GetHashCode()
        {
            return Name.GetHashCode() ^ MinimumVersion.GetHashCode() ^ MaximumVersion.GetHashCode();
        }

        public override string ToString()
        {
            if (MinimumVersion.ToString() == "0.0.0.0")
            {
                if (MaximumVersion.Major == int.MaxValue)
                {
                    return Name;
                }
                else
                {
                    return Name + ", version <" + MaximumVersion.ToString();
                }
            }
            else
            {
                if (MaximumVersion.Major == int.MaxValue)
                {
                    return Name + ", version >" + MinimumVersion.ToString();
                }
                else if (MinimumVersion == MaximumVersion)
                {
                    return Name + ", version " + MinimumVersion.ToString();
                }
                else
                {
                    return Name + ", version " + MinimumVersion.ToString() + "-" + MaximumVersion.ToString();
                }
            }
        }

        public PlugInReference Clone()
        {
            return new PlugInReference(Name, MinimumVersion, MaximumVersion);
        }

        object ICloneable.Clone()
        {
            return Clone();
        }

        /// <returns>Returns true when the reference is valid.</returns>
        public bool Check(Dictionary<string, Version> addIns, out Version versionFound)
        {
            if (addIns.TryGetValue(Name, out versionFound))
            {
                return CompareVersion(versionFound, MinimumVersion) >= 0
                    && CompareVersion(versionFound, MaximumVersion) <= 0;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// Compares two versions and ignores unspecified fields (unlike Version.CompareTo)
        /// </summary>
        /// <returns>-1 if a &lt; b, 0 if a == b, 1 if a &gt; b</returns>
        int CompareVersion(Version a, Version b)
        {
            if (a.Major != b.Major)
            {
                return a.Major > b.Major ? 1 : -1;
            }
            if (a.Minor != b.Minor)
            {
                return a.Minor > b.Minor ? 1 : -1;
            }
            if (a.Build < 0 || b.Build < 0)
                return 0;
            if (a.Build != b.Build)
            {
                return a.Build > b.Build ? 1 : -1;
            }
            if (a.Revision < 0 || b.Revision < 0)
                return 0;
            if (a.Revision != b.Revision)
            {
                return a.Revision > b.Revision ? 1 : -1;
            }
            return 0;
        }

        static Version entryVersion;
        /// <summary>
        /// 解析版本
        /// </summary>
        /// <param name="version">版本号，当以"@"开头时如果是<see cref="PlugInConst.CoreVersion"/>的常量值则表示与当前插件系统版本同步，否则请传递插件dll文件名并且hintPath参数为文件的目录路径</param>
        /// <param name="hintPath">插件dll文件的目录路径</param>
        /// <returns></returns>
        internal static Version ParseVersion(string version, string hintPath)
        {
            if (version.IsNullOrEmpty())
            {
                return new Version(0, 0, 0, 0);
            }
            if (version.StartsWith("@"))
            {
                if (version == "@CoreVersion")
                {
                    if (entryVersion == null)
                    {
                        entryVersion = new Version(RevisionClass.FullVersion);
                    }

                    if (hintPath != null)
                    {
                        string fileName = Path.Combine(hintPath, version.Substring(1));
                        try
                        {
                            FileVersionInfo info = FileVersionInfo.GetVersionInfo(fileName);
                            return new Version(info.FileMajorPart, info.FileMinorPart, info.FileBuildPart, info.FilePrivatePart);
                        }
                        catch (FileNotFoundException ex)
                        {
                            throw new Exception("Cannot get version '" + version + "': " + ex.Message);
                        }
                    }

                    return entryVersion;
                }
                return new Version(0, 0, 0, 0);
            }
            else
            {
                return new Version(version);
            }
        }

        public static PlugInReference Create(Properties properties, string hintPath)
        {
            PlugInReference reference = new PlugInReference(properties["addin"]);

            string version = properties["version"];

            if (version != null && version.Length > 0)
            {
                int pos = version.IndexOf('-');
                if (pos > 0)
                {
                    reference.MinimumVersion = ParseVersion(version.Substring(0, pos), hintPath);
                    reference.MaximumVersion = ParseVersion(version.Substring(pos + 1), hintPath);
                }
                else
                {
                    reference.MaximumVersion = reference.MinimumVersion = ParseVersion(version, hintPath);
                }
            }

            reference.RequirePreload = string.Equals(properties["requirePreload"], "true", StringComparison.OrdinalIgnoreCase);

            return reference;
        }
    }
}
