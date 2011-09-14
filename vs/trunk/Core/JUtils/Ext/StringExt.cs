using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

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

        /// <summary>
        /// 指示当前字符串是否为IP地址
        /// </summary>
        /// <param name="scope"></param>
        /// <returns></returns>
        public static bool IsIP(this string scope)
        {
            return Regex.IsMatch(scope, @"^((2[0-4]\d|25[0-5]|[01]?\d\d?)\.){3}(2[0-4]\d|25[0-5]|[01]?\d\d?)$");
        }

        /// <summary>
        /// 指示当前字符串是否为正确的Url
        /// </summary>
        /// <param name="scope"></param>
        /// <returns></returns>
        public static bool IsURL(this string scope)
        {
            return Regex.IsMatch(scope, @"^(http|https)\://([a-zA-Z0-9\.\-]+(\:[a-zA-Z0-9\.&%\$\-]+)*@)*((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|localhost|([a-zA-Z0-9\-]+\.)*[a-zA-Z0-9\-]+\.(com|edu|gov|int|mil|net|org|biz|arpa|info|name|pro|aero|coop|museum|[a-zA-Z]{1,10}))(\:[0-9]+)*(/($|[a-zA-Z0-9\.\,\?\'\\\+&%\$#\=~_\-]+))*$");
        }

        /// <summary>
        /// 指示当前字符串是否符合email格式
        /// </summary>
        /// <param name="scope"></param>
        /// <returns></returns>
        public static bool IsEmail(this string scope)
        {
            return Regex.IsMatch(scope, @"^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$");
        }

        /// <summary>
        /// 指示当前字符串是否符合email格式(仅验证@后面的格式)
        /// </summary>
        /// <param name="scope"></param>
        /// <returns></returns>
        public static bool IsDoEmail(this string scope)
        {
            return Regex.IsMatch(scope, @"^@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$");
        }

        /// <summary>
        /// 移除Html标记
        /// </summary>
        /// <param name="scope"></param>
        public static void RemoveHtml(this string scope)
        {
            string regexstr = @"<[^>]*>";
            scope = Regex.Replace(scope, regexstr, string.Empty, RegexOptions.IgnoreCase);
        }

        /// <summary>
        /// 过滤HTML中的不安全标签
        /// </summary>
        /// <param name="scope"></param>
        public static void RemoveUnsafeHtml(this string scope)
        {
            scope = Regex.Replace(scope, @"(\<|\s+)o([a-z]+\s?=)", "$1$2", RegexOptions.IgnoreCase);
            scope = Regex.Replace(scope, @"(script|frame|form|meta|behavior|style)([\s|:|>])+", "$1.$2", RegexOptions.IgnoreCase);
        }
    }
}
