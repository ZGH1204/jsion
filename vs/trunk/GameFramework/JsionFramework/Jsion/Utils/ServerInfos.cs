using System;
using System.Collections.Generic;
using System.Text;

using System.Web;

namespace Jsion.Utils
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
        /// 开机运行时长
        /// </summary>
        /// <returns></returns>
        public static string ServerStart()
        {
            return ((Double)System.Environment.TickCount / 3600000).ToString("N2");// 开机运行时长
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
