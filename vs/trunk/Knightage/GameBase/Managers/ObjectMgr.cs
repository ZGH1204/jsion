using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.Specialized;

namespace GameBase.Managers
{
    public class ObjectMgr<T> where T:class
    {
        private readonly HybridDictionary m_objects = new HybridDictionary();

        public virtual void Add(int id, T obj)
        {
            if (obj == null) return;

            lock (m_objects.SyncRoot)
            {
                if (m_objects.Contains(id)) return;

                m_objects.Add(id, obj);
            }
        }

        public virtual T Remove(int id)
        {
            lock (m_objects.SyncRoot)
            {
                if (m_objects.Contains(id))
                {
                    T obj = m_objects[id] as T;

                    m_objects.Remove(id);

                    return obj;
                }

                return default(T);
            }
        }

        public virtual void Remove(T obj)
        {
            int[] keys = GetKeys();

            foreach (int key in keys)
            {
                if (m_objects[key] == obj)
                {
                    Remove(key);
                }
            }
        }

        public virtual bool Contains(int id)
        {
            lock (m_objects.SyncRoot)
            {
                return m_objects.Contains(id);
            }
        }

        public virtual int GetID(Predicate<T> match)
        {
            int[] keys = GetKeys();

            foreach (int key in keys)
            {
                if (match(m_objects[key] as T))
                {
                    return key;
                }
            }

            return 0;
        }

        public T this[int id]
        {
            get
            {
                lock (m_objects.SyncRoot)
                {
                    return m_objects[id] as T;
                }
            }
        }

        public virtual void ForEach(Action<T> action)
        {
            T[] list = GetArray();

            foreach (T obj in list)
            {
                action(obj);
            }
        }

        public virtual int[] GetKeys()
        {
            int[] list;

            lock (m_objects.SyncRoot)
            {
                list = new int[m_objects.Count];

                m_objects.Keys.CopyTo(list, 0);
            }

            return list;
        }

        public virtual T[] GetArray()
        {
            T[] list;

            lock (m_objects.SyncRoot)
            {
                list = new T[m_objects.Count];

                m_objects.Values.CopyTo(list, 0);
            }

            return list;
        }

        public virtual int Count { get { return m_objects.Count; } }
    }
}
