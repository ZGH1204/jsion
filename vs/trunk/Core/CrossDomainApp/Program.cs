using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using CrossDomainApp.Core;
using System.IO;

namespace CrossDomainApp
{
    class Program
    {
        static void Main(string[] args)
        {
            string val = ConfigurationManager.AppSettings["SimpleCheck"];
            CrossGlobal.SimpleCheck = (bool)Convert.ChangeType(val, CrossGlobal.SimpleCheck.GetType());


            val = ConfigurationManager.AppSettings["Condition"];
            if (!string.IsNullOrEmpty(val.Trim())) CrossGlobal.CONDITION = val;

            val = ConfigurationManager.AppSettings["CrossFile"];

            string policy;

            if (string.IsNullOrEmpty(val))
            {
                policy = CrossGlobal.POLICY_XML;
                Console.WriteLine("使用默认跨域文件");
                Console.WriteLine(CrossGlobal.POLICY_XML);
                Console.WriteLine();
            }
            else
            {
                try
                {
                    policy = File.ReadAllText(val);
                }
                catch (Exception ex)
                {
                    Console.ForegroundColor = ConsoleColor.Yellow;
                    Console.WriteLine(ex.Message);
                    Console.ResetColor();

                    Console.WriteLine();

                    Console.WriteLine("使用默认跨域文件:");
                    Console.BackgroundColor = ConsoleColor.White;
                    Console.ForegroundColor = ConsoleColor.Black;
                    Console.WriteLine(CrossGlobal.POLICY_XML);
                    Console.WriteLine();
                    Console.ResetColor();
                    policy = CrossGlobal.POLICY_XML;
                }
            }

            CrossGlobal.POLICY = Encoding.UTF8.GetBytes(policy);

            val = ConfigurationManager.AppSettings["Port"];

            int port = int.Parse(val);

            if (port == 0)
            {
                port = 843;
            }

            CrossGlobal.Server.Listen(port);

            while (true)
            {
                Console.ReadLine();
            }
        }
    }
}
