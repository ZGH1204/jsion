#if NET1
#else

using System;
using System.Collections.Generic;
using System.Text;

namespace Sjs.Common.Generic
{
    /// <summary>
    /// Singleton∑∫–Õ¿‡
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public sealed class Singleton<T> where T : new()
    {
        private static T instance = new T();

        private static object lockHelper = new object();

        private Singleton() { }

        public static T GetInstance()
        {
            if (instance == null)
            {
                lock (lockHelper)
                {
                    if (instance == null)
                    {
                        instance = new T();
                    }
                }
            }

            return instance;
        }

        public void SetInstance(T value)
        {
            instance = value;
        }
    }
}
#endif