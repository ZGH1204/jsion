#if NET1
#else

using System;
using System.Collections.Generic;
using System.Text;

namespace Sjs.Common.Generic
{
    /// <summary>
    /// SortedList泛型类
    /// </summary>
    /// <typeparam name="T">占位符(下同)</typeparam>
    [Serializable]
    public class SortedList<TKey, TValue> : System.Collections.Generic.SortedList<TKey, TValue>, ISjsCollection<KeyValuePair<TKey, TValue>>
    {
        public SortedList() : base() { }

        public SortedList(IComparer<TKey> comparer) : base(comparer) { }

        public SortedList(IDictionary<TKey, TValue> dictionary) : base(dictionary) { }

        public SortedList(int capacity) : base(capacity) { }

        public SortedList(IDictionary<TKey, TValue> dictionary, IComparer<TKey> comparer) : base(dictionary, comparer) { }

        public SortedList(int capacity, IComparer<TKey> comparer) : base(capacity, comparer) { }


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
                SortedList<TKey, TValue> list = obj as SortedList<TKey, TValue>;
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