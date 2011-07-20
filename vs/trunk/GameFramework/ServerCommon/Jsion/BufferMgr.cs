using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using log4net;
using System.Reflection;

namespace Jsion
{
    public class BufferMgr
    {
        public static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType); //产生工作日志

        public static readonly int BUFFER_SIZE = 2048;
        private static Queue m_buffersPool;

        private BufferMgr()
        {
            
        }

        public static bool Setup(int count)
        {
           if (m_buffersPool != null) return true;

           int m_poolSize = count;

            m_buffersPool = new Queue(m_poolSize);

            for (int i = 0; i < m_poolSize; i++)
            {
                m_buffersPool.Enqueue(new byte[BUFFER_SIZE]);
            }

            log.InfoFormat("Allocated buffers: {0}", m_poolSize);

            return true;
        }

        public static byte[] AcquireBuffer()
        {
            lock (m_buffersPool.SyncRoot)
            {
                if (m_buffersPool.Count > 0)
                {
                    return (byte[])m_buffersPool.Dequeue();
                }
            }
            log.Warn("Buffers pool is empty!");
            return new byte[BUFFER_SIZE];
        }

        public static void ReleaseBuffer(byte[] buffer)
        {
            if (buffer == null || GC.GetGeneration(buffer) < GC.MaxGeneration) return;

            lock (m_buffersPool.SyncRoot)
            {
                m_buffersPool.Enqueue(buffer);
            }
        }
    }
}
