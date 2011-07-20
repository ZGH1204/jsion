using System;
using System.Collections.Generic;
using System.Text;

using System.Web;

namespace Sjs.Common
{
    public class ServerInfos
    {
        /// <summary>
        /// 操作系统
        /// </summary>
        /// <returns></returns>
        public static string ServerOS()
        {
            return Environment.OSVersion.ToString();
        }
        /// <summary>
        /// CPU个数
        /// </summary>
        /// <returns></returns>
        public static string CpuSum()
        {
            return Environment.GetEnvironmentVariable("NUMBER_OF_PROCESSORS");
        }
        /// <summary>
        /// CPU类型
        /// </summary>
        /// <returns></returns>
        public static string CpuType()
        {
            return Environment.GetEnvironmentVariable("PROCESSOR_IDENTIFIER");
        }
        /// <summary>
        /// 信息服务软件
        /// </summary>
        /// <returns></returns>
        public static string ServerSoft()
        {
            return HttpContext.Current.Request.ServerVariables["SERVER_SOFTWARE"];
        }
        /// <summary>
        /// 服务器名
        /// </summary>
        /// <returns></returns>
        public static string MachineName()
        {
            return HttpContext.Current.Server.MachineName;
        }
        /// <summary>
        /// 服务器域名
        /// </summary>
        /// <returns></returns>
        public static string ServerName()
        {
            return HttpContext.Current.Request.ServerVariables["SERVER_NAME"];// 服务器域名
        }
        /// <summary>
        /// 虚拟服务绝对路径
        /// </summary>
        /// <returns></returns>
        public static string ServerPath()
        {
            return HttpContext.Current.Request.ServerVariables["APPL_PHYSICAL_PATH"];// 虚拟服务绝对路径
        }
        /// <summary>
        /// DotNET 版本
        /// </summary>
        /// <returns></returns>
        public static string ServerNet()
        {
            return ".NET CLR " + Environment.Version.ToString(); // DotNET 版本
        }
        /// <summary>
        /// 服务器时区
        /// </summary>
        /// <returns></returns>
        public static string ServerArea()
        {
            return (DateTime.Now - DateTime.UtcNow).TotalHours > 0 ? "+" + (DateTime.Now - DateTime.UtcNow).TotalHours.ToString() : (DateTime.Now - DateTime.UtcNow).TotalHours.ToString();// 服务器时区
        }
        /// <summary>
        /// 请求超时时间
        /// </summary>
        /// <returns></returns>
        public static string ServerTimeOut()
        {
            return HttpContext.Current.Server.ScriptTimeout.ToString(); // 脚本超时时间
        }
        /// <summary>
        /// 开机运行时长
        /// </summary>
        /// <returns></returns>
        public static string ServerStart()
        {
            return ((Double)System.Environment.TickCount / 3600000).ToString("N2");// 开机运行时长
        }
        /// <summary>
        /// Session总数
        /// </summary>
        /// <returns></returns>
        public static string ServerSessions()
        {
            return HttpContext.Current.Session.Contents.Count.ToString();// Session总数
        }
        /// <summary>
        /// Application总数
        /// </summary>
        /// <returns></returns>
        public static string ServerApp()
        {
            return HttpContext.Current.Application.Contents.Count.ToString(); // Application总数
        }
        /// <summary>
        /// 应用程序缓存总数
        /// </summary>
        /// <returns></returns>
        public static string ServerCache()
        {
            return HttpContext.Current.Cache.Count.ToString(); //应用程序缓存总数
        }
        /// <summary>
        /// 服务器Hostname
        /// </summary>
        /// <returns></returns>
        public static string ServerHostname()
        {
            return System.Net.Dns.GetHostName();
        }
        /// <summary>
        /// 服务器IP
        /// </summary>
        /// <returns></returns>
        public static string ServerIP()
        {
            string hostname = System.Net.Dns.GetHostName();

            System.Net.IPHostEntry ip = System.Net.Dns.GetHostEntry(hostname);

            string ipaddress = "";

            foreach (System.Net.IPAddress ipA in ip.AddressList)
            {
                ipaddress = ipaddress + ipA.ToString() + "\n";
            }

            return ipaddress;
        }
    }
}
