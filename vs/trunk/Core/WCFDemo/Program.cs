using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using WCF;

namespace WCFDemo
{
    class Program
    {
        static WCFStartuper wcf;
        static void Main(string[] args)
        {
            wcf = new WCFStartuper(typeof(ServiceDemo));

            wcf.Start();

            Console.WriteLine("WCF启动成功");

            Console.WriteLine("按任意键退出..");

            Console.ReadKey();

            wcf.Stop();
        }
    }
}
