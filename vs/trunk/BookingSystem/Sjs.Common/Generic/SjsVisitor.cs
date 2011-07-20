#if NET1
#else

using System;
using System.Collections.Generic;
using System.Text;

namespace Sjs.Common.Generic
{
    /// <summary>
    /// 累加数访问类
    /// </summary>
    public sealed class SumVisitor : ISjsVisitor<int>
    {

        private int sum;

        public SumVisitor() { }

        public void Visit(int obj)
        {
            sum += obj;
        }

        public bool HasDone
        {
            get
            {
                return false;
            }
        }

        public int Sum
        {
            get
            {
                return sum;
            }
        }
    }

    /// <summary>
    /// 计数访问类
    /// </summary>
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public sealed class CountVisitor<T> : ISjsVisitor<T>
    {

        int count;

        public CountVisitor()
        {

        }

        public bool HasDone
        {
            get
            {
                return false;
            }
        }

        public void Visit(T obj)
        {
            count++;
        }

        public void ResetCount()
        {
            count = 0;
        }

        public int Count
        {
            get
            {
                return count;
            }
        }
    }

    /// <summary>
    /// 查找指定对象访问类
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public sealed class FindingVisitor<T> : ISjsVisitor<T> where T : IComparable
    {

        private bool found = false;
        private T searchObj;

        public FindingVisitor(T searchobj)
        {
            this.searchObj = searchobj;
        }

        public bool HasDone
        {
            get
            {
                return found;
            }
        }

        public void Visit(T obj)
        {
            if (obj.CompareTo(searchObj) == 0)
            {
                found = true;
            }
        }

        public bool Found
        {
            get
            {
                return found;
            }
        }

        public T SearchResult
        {
            get
            {
                return searchObj;
            }
        }
    }
}
#endif