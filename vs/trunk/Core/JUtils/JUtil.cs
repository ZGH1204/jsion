using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Net;
using System.Net.Sockets;

namespace JUtils
{
    public class JUtil
    {
        #region 当前操作系统判断

        /// <summary>
        /// 获取一个值,该值指示当前进程是否运行于64位的系统中
        /// </summary>
        public static bool IsRunningOn64Bit
        {
            get { return (IntPtr.Size == sizeof(long)); }
        }

        /// <summary>
        /// 获取一个值,该值指示当前操作系统是否为 Windows 2000或更高版本
        /// </summary>
        public static bool IsWindows2000OrNewer
        {
            get { return (Environment.OSVersion.Platform == PlatformID.Win32NT) && (Environment.OSVersion.Version.Major >= 5); }
        }

        /// <summary>
        /// 获取一个值,该值指示当前操作系统是否为 Windows XP或更高版本
        /// </summary>
        public static bool IsWindowsXpOrNewer
        {
            get
            {
                return
                    (Environment.OSVersion.Platform == PlatformID.Win32NT) &&
                    (
                        (Environment.OSVersion.Version.Major >= 6) ||
                        (
                            (Environment.OSVersion.Version.Major == 5) &&
                            (Environment.OSVersion.Version.Minor >= 1)
                        )
                    );
            }
        }

        /// <summary>
        /// 获取一个值,该值指示当前操作系统是否为 Windows Vista或更高版本
        /// </summary>
        public static bool IsWindowsVistaOrNewer
        {
            get { return (Environment.OSVersion.Platform == PlatformID.Win32NT) && (Environment.OSVersion.Version.Major >= 6); }
        }

        #endregion

        #region 字符串操作

        /// <summary>
        /// 字符串如果操过指定长度则将超出的部分用指定字符串代替
        /// </summary>
        /// <param name="p_SrcString">要检查的字符串</param>
        /// <param name="p_Length">指定长度</param>
        /// <param name="p_TailString">用于替换的字符串</param>
        /// <returns>截取后的字符串</returns>
        public static string GetSubString(string p_SrcString, int p_Length, string p_TailString)
        {
            return GetSubString(p_SrcString, 0, p_Length, p_TailString);
        }

        /// <summary>
        /// 取指定长度的字符串
        /// </summary>
        /// <param name="p_SrcString">要检查的字符串</param>
        /// <param name="p_StartIndex">起始位置</param>
        /// <param name="p_Length">指定长度</param>
        /// <param name="p_TailString">用于替换的字符串</param>
        /// <returns>截取后的字符串</returns>
        public static string GetSubString(string p_SrcString, int p_StartIndex, int p_Length, string p_TailString)
        {


            string myResult = p_SrcString;

            //当是日文或韩文时(注:中文的范围:\u4e00 - \u9fa5, 日文在\u0800 - \u4e00, 韩文为\xAC00-\xD7A3)
            if (System.Text.RegularExpressions.Regex.IsMatch(p_SrcString, "[\u0800-\u4e00]+") ||
                System.Text.RegularExpressions.Regex.IsMatch(p_SrcString, "[\xAC00-\xD7A3]+"))
            {
                //当截取的起始位置超出字段串长度时
                if (p_StartIndex >= p_SrcString.Length)
                {
                    return "";
                }
                else
                {
                    return p_SrcString.Substring(p_StartIndex,
                                                   ((p_Length + p_StartIndex) > p_SrcString.Length) ? (p_SrcString.Length - p_StartIndex) : p_Length);
                }
            }


            if (p_Length >= 0)
            {
                byte[] bsSrcString = Encoding.Default.GetBytes(p_SrcString);

                //当字符串长度大于起始位置
                if (bsSrcString.Length > p_StartIndex)
                {
                    int p_EndIndex = bsSrcString.Length;

                    //当要截取的长度在字符串的有效长度范围内
                    if (bsSrcString.Length > (p_StartIndex + p_Length))
                    {
                        p_EndIndex = p_Length + p_StartIndex;
                    }
                    else
                    {   //当不在有效范围内时,只取到字符串的结尾

                        p_Length = bsSrcString.Length - p_StartIndex;
                        p_TailString = "";
                    }



                    int nRealLength = p_Length;
                    int[] anResultFlag = new int[p_Length];
                    byte[] bsResult = null;

                    int nFlag = 0;
                    for (int i = p_StartIndex; i < p_EndIndex; i++)
                    {

                        if (bsSrcString[i] > 127)
                        {
                            nFlag++;
                            if (nFlag == 3)
                            {
                                nFlag = 1;
                            }
                        }
                        else
                        {
                            nFlag = 0;
                        }

                        anResultFlag[i] = nFlag;
                    }

                    if ((bsSrcString[p_EndIndex - 1] > 127) && (anResultFlag[p_Length - 1] == 1))
                    {
                        nRealLength = p_Length + 1;
                    }

                    bsResult = new byte[nRealLength];

                    Array.Copy(bsSrcString, p_StartIndex, bsResult, 0, nRealLength);

                    myResult = Encoding.Default.GetString(bsResult);

                    myResult = myResult + p_TailString;
                }
            }

            return myResult;
        }

        #endregion

        /// <summary>
        /// 根据阿拉伯数字返回月份的名称(可更改为某种语言)[从1开始的索引]
        /// </summary>
        public static string[] Monthes
        {
            get
            {
                return new string[] { "", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" };
            }
        }

        /// <summary>
        /// 返回与当前时间间隔指定时间(分钟)的日期
        /// 格式：yyyy-MM-dd HH:mm:ss
        /// </summary>
        /// <param name="minutes"></param>
        /// <returns></returns>
        public static string AddedTime(int minutes)
        {
            return DateTime.Now.AddMinutes(minutes).ToString("yyyy-MM-dd HH:mm:ss");
        }

        /// <summary>
        /// 返回与当前时间间隔指定时间(秒)的日期
        /// 格式：yyyy-MM-dd HH:mm:ss
        /// </summary>
        /// <param name="seconds"></param>
        /// <returns></returns>
        public static string AddedTime(uint seconds)
        {
            return DateTime.Now.AddSeconds(seconds).ToString("yyyy-MM-dd HH:mm:ss");
        }

        /// <summary>
        /// 获取本地IPv4地址
        /// </summary>
        /// <returns></returns>
        public static string GetLocalIP()
        {
            IPHostEntry entry = Dns.GetHostEntry(Dns.GetHostName());

            string ip = null;

            IPAddress[] list = entry.AddressList;

            foreach (IPAddress address in list)
            {
                if (address.AddressFamily == AddressFamily.InterNetwork)
                {
                    ip = address.ToString();
                    break;
                }
            }

            return ip;
        }

        /// <summary>
        /// 获取本地IPv6地址
        /// </summary>
        /// <returns></returns>
        public static string GetLocalIPv6()
        {
            IPHostEntry entry = Dns.GetHostEntry(Dns.GetHostName());

            string ip = null;

            IPAddress[] list = entry.AddressList;

            foreach (IPAddress address in list)
            {
                if (address.AddressFamily == AddressFamily.InterNetworkV6)
                {
                    ip = address.ToString();
                    break;
                }
            }

            return ip;
        }
    }
}
