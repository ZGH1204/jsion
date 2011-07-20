#if NET1
#else

using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.Serialization;

namespace Sjs.Common.Generic
{
    /// <summary>
    /// Dictionary泛型类
    /// </summary>
    /// <typeparam name="T">占位符(下同)</typeparam>
    [Serializable]
    public class Dictionary<TKey, TValue> : System.Collections.Generic.Dictionary<TKey, TValue>, ISjsCollection<KeyValuePair<TKey, TValue>>
    {
        public Dictionary() : base() { }

        public Dictionary(IDictionary<TKey, TValue> dictionary) : base(dictionary) { }

        public Dictionary(IEqualityComparer<TKey> comparer) : base(comparer) { }

        public Dictionary(int capacity) : base(capacity) { }

        public Dictionary(IDictionary<TKey, TValue> dictionary, IEqualityComparer<TKey> comparer) : base(dictionary, comparer) { }

        public Dictionary(int capacity, IEqualityComparer<TKey> comparer) : base(capacity, comparer) { }

        public Dictionary(SerializationInfo info, StreamingContext context) : base(info, context) { }

        public object SyncRoot
        {
            get
            {
                return this;
            }
        }

        public bool IsEmpty
        {
            get
            {
                return this.Count == 0;
            }
        }

        private int _fixedsize = default(int);
        public int FixedSize
        {
            get
            {
                return _fixedsize;
            }
            set
            {
                _fixedsize = value;
            }
        }

        public bool IsFull
        {
            get
            {
                if ((FixedSize != default(int)) && (this.Count >= FixedSize))
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }

        public string Version
        {
            get
            {
                return "1.0";
            }
        }

        public string Author
        {
            get
            {
                return "Discuz!NT";
            }
        }

        public bool IsReadOnly
        {
            get
            {
                return false;
            }
        }


        public new void Add(TKey tkey, TValue tvalue)
        {
            if (!this.IsFull)
            {
                base.Add(tkey, tvalue);
            }
        }


        public int CompareTo(object obj)
        {
            if (obj == null)
            {
                throw new ArgumentNullException("当前数据为空");
            }

            if (obj.GetType() == this.GetType())
            {
                Dictionary<TKey, TValue> list = obj as Dictionary<TKey, TValue>;
                return this.Count.CompareTo(list.Count);
            }
            else
            {
                return this.GetType().FullName.CompareTo(obj.GetType().FullName);
            }
        }
    }
}
#endif