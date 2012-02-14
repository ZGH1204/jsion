using System;
using System.IO;
using System.Xml.Serialization;
using System.Xml;
using System.Text;
using log4net;
using System.Reflection;

namespace JUtils
{
    /// <summary>
    /// SerializationHelper 的摘要说明。
    /// </summary>
    public class SerializationUtil
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        /// <summary>
        /// 泛型方法将指定对象序列化保存到文件中
        /// </summary>
        /// <typeparam name="T">要序列化的类型</typeparam>
        /// <param name="obj">要序列化的对象</param>
        /// <param name="filename">保存路径</param>
        public static void SaveXmlFromObj<T>(T obj, string filename)
        {
            if (obj == null) return;

            using (FileStream fs = new FileStream(filename, FileMode.OpenOrCreate, FileAccess.Write))
            {
                MemoryStream ms = new MemoryStream();
                XmlTextWriter xtw = new XmlTextWriter(ms, Encoding.UTF8);
                xtw.Formatting = Formatting.Indented;

                XmlSerializer xs = new XmlSerializer(typeof(T));

                try
                {
                    xs.Serialize(ms, obj);

                    byte[] bytes = ms.ToArray();

                    fs.Write(bytes, 0, bytes.Length);

                    fs.Flush();
                }
                catch (Exception ex)
                {
                    log.Error("序列化失败!", ex);
                }
            }
        }

        /// <summary>
        /// 泛型方法将指定Xml字符串数据反序列化为指定对象
        /// </summary>
        /// <typeparam name="T">反序列化后的类型</typeparam>
        /// <param name="xmlStr">Xml字符串数据</param>
        /// <returns></returns>
        public static T LoadObjFromXml<T>(string xmlStr)
        {
            using (MemoryStream ms = new MemoryStream())
            {
                using (StreamWriter sw = new StreamWriter(ms, Encoding.UTF8))
                {
                    sw.Write(xmlStr);
                    sw.Flush();
                    ms.Seek(0, SeekOrigin.Begin);

                    XmlSerializer xs = new XmlSerializer(typeof(T));

                    try
                    {
                        return ((T)xs.Deserialize(ms));
                    }
                    catch (Exception ex)
                    {
                        log.Error("反序列化失败!", ex);

                        return default(T);
                    }
                }
            }
        }

        /// <summary>
        /// 泛型方法将指定XmlNode对象反序列化为指定对象
        /// </summary>
        /// <typeparam name="T">反序列化后的类型</typeparam>
        /// <param name="node">XmlNode对象</param>
        /// <returns></returns>
        public static T LoadObjFromXml<T>(XmlNode node)
        {
            if (node == null) return default(T);

            return LoadObjFromXml<T>(node.OuterXml);
        }

        ///// <summary>
        ///// 反序列化
        ///// </summary>
        ///// <param name="type">对象类型</param>
        ///// <param name="filename">文件路径</param>
        ///// <returns></returns>
        //public static object Load(Type type, string filename)
        //{
        //    FileStream fs = null;
        //    try
        //    {
        //        // open the stream...
        //        fs = new FileStream(filename, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
        //        XmlSerializer serializer = new XmlSerializer(type);
        //        return serializer.Deserialize(fs);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //    finally
        //    {
        //        if (fs != null)
        //            fs.Close();
        //    }
        //}


        ///// <summary>
        ///// 序列化
        ///// </summary>
        ///// <param name="obj">对象</param>
        ///// <param name="filename">文件路径</param>
        //public static void Save(object obj, string filename)
        //{
        //    FileStream fs = null;
        //    // serialize it...
        //    try
        //    {
        //        fs = new FileStream(filename, FileMode.Create, FileAccess.Write, FileShare.ReadWrite);
        //        XmlSerializer serializer = new XmlSerializer(obj.GetType());
        //        serializer.Serialize(fs, obj);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //    finally
        //    {
        //        if (fs != null)
        //            fs.Close();
        //    }

        //}
    }
}
