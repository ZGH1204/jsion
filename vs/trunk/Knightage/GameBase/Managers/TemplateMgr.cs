using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Xml;
using System.IO;
using JUtils;
using log4net;
using System.Reflection;

namespace GameBase.Managers
{
    public class TemplateMgr<T> where T:Template
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private Dictionary<uint, T> m_list;

        private ReaderWriterLock m_lock;

        public TemplateMgr()
        {
            m_lock = new ReaderWriterLock();
        }

        public void Load(string path, string xpath)
        {
            if (m_list == null)
            {
                m_list = LoadItem(path, xpath);
            }
            else
            {
                Dictionary<uint, T> list = LoadItem(path, xpath);

                m_lock.AcquireWriterLock(Timeout.Infinite);

                try
                {
                    m_list = list;
                }
                catch { }
                finally
                {
                    m_lock.ReleaseWriterLock();
                }
            }
        }

        private Dictionary<uint, T> LoadItem(string path, string xpath)
        {
            Dictionary<uint, T> list = new Dictionary<uint, T>();

            XmlDocument doc = new XmlDocument();

            doc.Load(path);

            XmlNode node = doc.SelectSingleNode(xpath);

            T[] array = SerializationUtil.LoadObjFromXml<T[]>(node);

            if (array == null)
            {
                log.Warn("模板反序列化失败,请检查!");
                return null;
            }

            foreach (T item in array)
            {
                if (list.ContainsKey(item.TemplateID))
                {
                    log.WarnFormat("模板ID：{0} 已存在,请检查!", item.TemplateID);
                    continue;
                }

                list.Add(item.TemplateID, item);
            }

            return list;
        }

        public T FindTemplate(uint templateID)
        {
            m_lock.AcquireReaderLock(Timeout.Infinite);

            try
            {
                if (m_list.ContainsKey(templateID))
                {
                    return m_list[templateID];
                }
            }
            finally
            {
                m_lock.ReleaseReaderLock();
            }

            return default(T);
        }

        public virtual uint GetID(Predicate<T> match)
        {
            uint id = 0;

            m_lock.AcquireReaderLock(Timeout.Infinite);

            try
            {
                uint[] keys = new uint[m_list.Keys.Count];

                m_list.Keys.CopyTo(keys, 0);

                foreach (uint key in keys)
                {
                    if (match(m_list[key] as T))
                    {
                        id = key;
                        break;
                    }
                }
            }
            finally
            {
                m_lock.ReleaseReaderLock();
            }

            return id;
        }
    }
}
