using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Threading;

namespace GameBase.ServerConfigs
{
    [Serializable]
    public class GatewayInfo : Template
    {
        private bool m_fulled;
        private ReaderWriterLock m_locker = new ReaderWriterLock();

        [XmlAttribute]
        public string IP { get; set; }

        [XmlAttribute]
        public int Port { get; set; }

        [XmlIgnore]
        public bool Fulled
        {
            get
            {
                m_locker.AcquireReaderLock(int.MaxValue);

                try
                {
                    return m_fulled;
                }
                finally
                {
                    m_locker.ReleaseReaderLock();
                }
            }
            set
            {
                m_locker.AcquireWriterLock(int.MaxValue);

                try
                {
                    m_fulled = value;
                }
                finally
                {
                    m_locker.ReleaseWriterLock();
                }
            }
        }

        [XmlAttribute]
        public string Summary { get; set; }
    }
}
