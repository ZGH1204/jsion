using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.Specialized;

namespace GameBase.Managers
{
    public class ObjectMgr<TKey, TValue>
    {
        protected Dictionary<TKey, TValue> m_pool = new Dictionary<TKey, TValue>();
        protected List<TValue> m_list = new List<TValue>();

        public object SyncRoot { get; protected set; }

        protected int m_index = -1;

        public ObjectMgr()
        {
            SyncRoot = new object();
        }

        public TValue GetNext()
        {
            if (m_list.Count > 0)
            {
                m_index++;

                if (m_index >= m_list.Count)
                {
                    m_index = 0;
                }

                return m_list[m_index];
            }

            return default(TValue);
        }

        public TValue this[TKey key]
        {
            get
            {
                lock (SyncRoot)
                {
                    if (m_pool.ContainsKey(key))
                    {
                        return m_pool[key];
                    }
                }

                return default(TValue);
            }
        }

        public void Add(TKey key, TValue val)
        {
            lock (SyncRoot)
            {
                if (m_pool.ContainsKey(key))
                {
                    m_list.Remove(m_pool[key]);
                    m_list.Add(val);
                    m_pool[key] = val;
                }
                else
                {
                    m_list.Add(val);
                    m_pool.Add(key, val);
                }
            }
        }

        public bool Remove(TKey key)
        {
            lock (SyncRoot)
            {
                if (m_pool.ContainsKey(key))
                {
                    m_list.Remove(m_pool[key]);
                }

                return m_pool.Remove(key);
            }
        }

        public bool Contains(TKey key)
        {
            lock (SyncRoot)
            {
                return m_pool.ContainsKey(key);
            }
        }

        public bool Contains(TValue val)
        {
            lock (SyncRoot)
            {
                return m_pool.ContainsValue(val);
            }
        }

        public TValue[] Select(Predicate<TValue> match)
        {
            lock (SyncRoot)
            {
                List<TValue> list = new List<TValue>();

                foreach (TValue item in m_pool.Values)
                {
                    if (match(item))
                    {
                        list.Add(item);
                    }
                }

                return list.ToArray();
            }
        }

        public TValue SelectSingle(Predicate<TValue> match)
        {
            lock (SyncRoot)
            {
                foreach (TValue item in m_pool.Values)
                {
                    if (match(item))
                    {
                        return item;
                    }
                }

                return default(TValue);
            }
        }

        public void Clear()
        {
            lock (SyncRoot)
            {
                m_list.Clear();
                m_pool.Clear();
            }
        }

        public void ForEachKey(Action<TKey> action)
        {
            if (action == null) return;

            lock (SyncRoot)
            {
                foreach (TKey item in m_pool.Keys)
                {
                    action(item);
                }
            }
        }

        public void ForEach(Action<TValue> action)
        {
            if (action == null) return;

            lock (SyncRoot)
            {
                foreach (TValue item in m_list)
                {
                    action(item);
                }
            }
        }

        public int Count
        {
            get
            {
                lock (SyncRoot)
                {
                    return m_pool.Count;
                }
            }
        }
    }
}
