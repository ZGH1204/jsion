using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Data;
using System.IO;

namespace Sjs.Common
{
    /// <summary>
    /// Xml操作类
    /// </summary>
    public class XMLHelper
    {
        /// <summary>
        /// Xml文件的路径
        /// </summary>
        protected string strXmlFile;
        /// <summary>
        /// Xml文档类
        /// </summary>
        protected XmlDocument objXmlDoc = new XmlDocument();

        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="XmlFile">Xml文件路径</param>
        public XMLHelper(string XmlFile)
        {
            try
            {
                objXmlDoc.Load(XmlFile);
            }
            catch (Exception ex)
            {
                throw ex;
            }

            strXmlFile = XmlFile;
        }

        /// <summary>
        /// 获取Xml文件的DataView表示
        /// </summary>
        /// <param name="XmlPathNode"></param>
        /// <returns></returns>
        public DataView GetData(string XmlPathNode)
        {
            // 查找数据,返回一个DataView

            DataSet ds = new DataSet();

            StringReader read = new StringReader(objXmlDoc.SelectSingleNode(XmlPathNode).OuterXml);

            ds.ReadXml(read);

            return ds.Tables[0].DefaultView;
        }

        /// <summary>
        /// 替换指定的Xml路径的内容
        /// </summary>
        /// <param name="XmlPathNode"></param>
        /// <param name="Content"></param>
        public void SetXmlNodeContent(string XmlPathNode, string Content)
        {
            objXmlDoc.SelectSingleNode(XmlPathNode).InnerText = Content;
        }

        /// <summary>
        /// 删除指定节点
        /// </summary>
        /// <param name="Node"></param>
        public void DeleteNode(string Node)
        {
            string mainNode = Node.Substring(0, Node.LastIndexOf("/"));

            objXmlDoc.SelectSingleNode(mainNode).RemoveChild(objXmlDoc.SelectSingleNode(Node));
        }

        /// <summary>
        /// 插入一节点和此节点的一子节点
        /// </summary>
        /// <param name="MainNode">插入节点的父节点路径</param>
        /// <param name="ChildNode">插入节点的名称</param>
        /// <param name="Element">插入节点的子节点的名称</param>
        /// <param name="Content">插入节点的子节点的值</param>
        public void InsertNode(string MainNode, string ChildNode, string Element, string Content)
        {
            // 插入一节点和此节点的一子节点
            InsertNode(MainNode, ChildNode, new string[1] { Element }, new string[1] { Content });
        }

        /// <summary>
        /// 插入一节点和此节点的若干子节点,子节点数由参数Elements数组的个数决定
        /// </summary>
        /// <param name="MainNode">插入节点的父节点路径</param>
        /// <param name="ChildNode">插入节点的名称</param>
        /// <param name="Elements">插入节点的子节点的名称数组(与Contents参数一一对应)</param>
        /// <param name="Contents">插入节点的子节点的值数组(与Elements参数一一对应)</param>
        public void InsertNode(string MainNode, string ChildNode, string[] Elements, string[] Contents)
        {
            if ((Elements.Length <= 0) || (Contents.Length <= 0) || (Elements.Length != Contents.Length))
            {
                //throw new ArgumentException("Elements 和 Contents 不能为空或 Elements 和 Contents 参数个数不一致");
                return;
            }

            XmlNode objRootNode = objXmlDoc.SelectSingleNode(MainNode);

            XmlElement objChildNode = objXmlDoc.CreateElement(ChildNode);
            objRootNode.AppendChild(objChildNode);

            for (int i = 0; i < Elements.Length; i++)
            {
                XmlElement element = objXmlDoc.CreateElement(Elements[i]);
                element.InnerText = Contents[i];
                objChildNode.AppendChild(element);
            }
        }

        /// <summary>
        /// 创建一个节点
        /// </summary>
        /// <param name="XmlNode">节点名称</param>
        /// <returns>返回节点元素</returns>
        public XmlElement CreaterElement(string XmlNode)
        {
            return objXmlDoc.CreateElement(XmlNode);
        }

        /// <summary>
        /// 插入一个节点,带一属性
        /// </summary>
        /// <param name="MainNode">插入节点的父节点路径</param>
        /// <param name="Element">插入节点的名称</param>
        /// <param name="Attrib">插入节点的属性名称</param>
        /// <param name="AttribContent">插入节点的属性值</param>
        /// <param name="Content">插入节点的值</param>
        public void InsertElement(string MainNode, string Element, string Attrib, string AttribContent, string Content)
        {
            // 插入一个节点,带一属性
            XmlNode objNode = objXmlDoc.SelectSingleNode(MainNode);

            XmlElement objElement = objXmlDoc.CreateElement(Element);
            objElement.SetAttribute(Attrib, AttribContent);
            objElement.InnerText = Content;
            objNode.AppendChild(objElement);
        }

        /// <summary>
        /// 插入一个节点,不包含属性
        /// </summary>
        /// <param name="MainNode">插入节点的父节点路径</param>
        /// <param name="Element">插入节点的名称</param>
        /// <param name="Content">插入节点的值</param>
        public void InsertElement(string MainNode, string Element, string Content)
        {
            // 插入一个节点,不属性
            XmlNode objNode = objXmlDoc.SelectSingleNode(MainNode);

            XmlElement objElement = objXmlDoc.CreateElement(Element);
            objElement.InnerText = Content;
            objNode.AppendChild(objElement);
        }

        /// <summary>
        /// 获取一个指定的Xml节点
        /// </summary>
        /// <param name="XmlNode">Xml节点路径</param>
        /// <returns>Xml节点</returns>
        public XmlNode GetXmlNode(string XmlNode)
        {
            return objXmlDoc.SelectSingleNode(XmlNode);
        }

        /// <summary>
        /// 获取根节点
        /// </summary>
        /// <returns>根节点</returns>
        public XmlNode GetRootNode()
        {
            return objXmlDoc.FirstChild.NextSibling;
        }

        /// <summary>
        /// 清空Xml
        /// </summary>
        public void Clear()
        {
            this.GetRootNode().RemoveAll();
        }

        /// <summary>
        /// 保存文档
        /// </summary>
        public void Save()
        {
            // 保存文档
            try
            {
                objXmlDoc.Save(strXmlFile);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
