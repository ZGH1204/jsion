using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;

namespace Jsion.Utils
{
    public class NetWorkUtil
    {
        public static IPAddress getLocalIPv6()
        {
            try
            {
                IPAddress[] ipList = Dns.GetHostAddresses(Dns.GetHostName());
                foreach (IPAddress ip in ipList)
                {
                    if (ip.IsIPv6LinkLocal) return ip;
                }
            }
            catch { }
            return null;
        }

        //public static IPAddress getLocalIPv4()
        //{
        //    return IPAddress.Any;
        //    try
        //    {
        //        IPAddress[] ipList = Dns.GetHostAddresses(Dns.GetHostName());
        //        foreach (IPAddress ip in ipList)
        //        {
        //            if (ip.IsIPv6LinkLocal) continue;
        //            return ip;
        //        }
        //    }
        //    catch {}
        //    return null;
        //}

        //public static string getLoclIPv4Str()
        //{
        //    try
        //    {
        //        IPAddress ip = getLocalIPv4();
        //        if (ip == null) return null;
        //        return ip.ToString();
        //    }
        //    catch {}

        //    return null;
        //}

        public static string getLoclIPv6Str()
        {
            try
            {
                IPAddress ip = getLocalIPv6();
                if (ip == null) return null;
                return ip.ToString();
            }
            catch { }

            return null;
        }
    }
}
