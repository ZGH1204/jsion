using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using System.Reflection;
using log4net;

namespace Net
{
    public class BufferMgr
    {
        public static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType); //产生工作日志

        private static int m_buffSize = 2048;
        private static Queue m_buffersPool;

        private BufferMgr()
        {

        }

        public static bool Setup(int buffSize, int count)
        {
            if (m_buffersPool != null) return true;

            m_buffSize = buffSize;
            int m_poolSize = count;

            m_buffersPool = new Queue(m_poolSize);

            for (int i = 0; i < m_poolSize; i++)
            {
                m_buffersPool.Enqueue(new byte[m_buffSize]);
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

            return new byte[m_buffSize];
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
