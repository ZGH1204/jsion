using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace System
{
    public static class StringExt
    {
        /// <summary>
        /// 指示当前字符串是否为空
        /// </summary>
        /// <param name="scope"></param>
        /// <returns></returns>
        public static bool IsNullOrEmpty(this string scope)
        {
            return string.IsNullOrEmpty(scope);
        }

        /// <summary>
        /// 指示当前字符串是否不为空
        /// </summary>
        /// <param name="scope"></param>
        /// <returns></returns>
        public static bool IsNotNullOrEmpty(this string scope)
        {
            return !string.IsNullOrEmpty(scope);
        }
    }
}
