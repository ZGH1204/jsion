using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using log4net;
using System.Reflection;

namespace PlugIn.Core
{
    public class PlugInTreeNode
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        readonly object lockObj = new object();

        public Dictionary<string, PlugInTreeNode> Children = new Dictionary<string, PlugInTreeNode>();

        public List<Codon> Codons { get; private set; }

        public PlugInTreeNode CreatePath(string path)
        {
            if (path.IsNullOrEmpty()) return this;

            string[] splitPaths = path.Split(new char[] { '/' }, StringSplitOptions.RemoveEmptyEntries);

            if (splitPaths.Length == 0) return this;

            PlugInTreeNode current = this;

            foreach (string p in splitPaths)
            {
                if (!current.Children.ContainsKey(p))
                {
                    current.Children[p] = new PlugInTreeNode();
                }

                current = current.Children[p];
            }

            return current;
        }

        public void AddCodons(List<Codon> newCodons)
        {
            if (newCodons == null) throw new ArgumentNullException("newCodons");

            lock (lockObj)
            {
                if (Codons == null)
                {
                    Codons = new List<Codon>();
                }

                Codons.AddRange(newCodons);
            }
        }



        public bool ExistsTreeNode(string path)
        {
            if (path.IsNullOrEmpty())
            {
                return true;
            }

            string[] splitPaths = path.Split(new char[] { '/' }, StringSplitOptions.RemoveEmptyEntries);

            if (splitPaths.Length == 0) return true;

            PlugInTreeNode current = this;

            foreach (string p in splitPaths)
            {
                if (!current.Children.TryGetValue(p, out current))
                {
                    return false;
                }
            }

            return true;
        }

        public PlugInTreeNode GetTreeNode(string path)
        {
            return GetTreeNode(path, true);
        }

        public PlugInTreeNode GetTreeNode(string path, bool throwOnNotFound)
        {
            if (path.IsNullOrEmpty()) return this;

            string[] splitPaths = path.Split(new char[] { '/' }, StringSplitOptions.RemoveEmptyEntries);

            if (splitPaths.Length == 0) return this;

            PlugInTreeNode current = this;

            foreach (string p in splitPaths)
            {
                if (current == null || !current.Children.TryGetValue(p, out current))
                {
                    if (throwOnNotFound)
                    {
                        log.ErrorFormat("指定扩展点路径不存在. Not found path is {0} , full path is {1}", p, path);
                        return null;
                        //throw new Exception("指定扩展点路径不存在. Not found path is " + p + " , full path is " + path);
                    }
                    else
                    {
                        return null;
                    }
                }
            }

            return current;
        }







        public List<T> BuildChildItems<T>(object caller)
        {
            var codons = this.Codons;
            List<T> items = new List<T>(codons.Count);

            foreach (Codon codon in codons)
            {
                ArrayList subItems = null;
                if (Children.ContainsKey(codon.ID))
                {
                    subItems = Children[codon.ID].BuildChildItems(caller);
                }

                object rlt = codon.BuildItem(caller, subItems);

                if (rlt == null)
                {
                    continue;
                }

                if (rlt is T)
                {
                    items.Add((T)rlt);
                }
                else
                {
                    throw new Exception("The AddInTreeNode <" + codon.Name + " id='" + codon.ID
                                                   + "'> returned an instance of " + rlt.GetType().FullName
                                                   + " but the type " + typeof(T).FullName + " is expected.");
                }
            }

            return items;
        }


        /// <summary>
        /// 创建当前节点下的所有子对象
        /// </summary>
        /// <param name="caller"></param>
        /// <returns></returns>
        public ArrayList BuildChildItems(object caller)
        {
            var codons = Codons;

            ArrayList items = new ArrayList(codons.Count);

            foreach (Codon codon in codons)
            {
                ArrayList subItems = null;

                if (Children.ContainsKey(codon.ID))
                {
                    subItems = Children[codon.ID].BuildChildItems(caller);
                }

                object rlt = codon.BuildItem(caller, subItems);

                if (rlt == null)
                {
                    continue;
                }

                items.Add(items);
            }

            return items;
        }

        /// <summary>
        /// 在当前节点下创建指定的子对象
        /// </summary>
        /// <param name="childItemID"></param>
        /// <param name="caller"></param>
        /// <param name="subItems"></param>
        /// <returns></returns>
        public object BuildChildItem(string childItemID, object caller, ArrayList subItems)
        {
            foreach (Codon codon in Codons)
            {
                if (codon.ID == childItemID)
                {
                    return codon.BuildItem(caller, subItems);
                }
            }

            throw new Exception("Treepath not found: " + childItemID);
        }
    }
}
