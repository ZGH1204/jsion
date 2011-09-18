using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JUtils;
using System.Reflection;

namespace WinService
{
    class Program
    {
        static void Main(string[] args)
        {
            ResourceUtil.ExtractResourceSafe("LogConfig.xml", "LogConfig.xml", Assembly.GetAssembly(typeof(ResourceUtil)));

            //Console.Write(WinServiceConfig.WinConfig.ControlPort);

            Console.ReadKey();
        }
    }
}
