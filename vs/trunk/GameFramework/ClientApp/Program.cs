using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Jsion.NetWork.Sockets;
using Jsion.Utils;
using System.Reflection;

namespace ClientApp
{
    class Program
    {
        static void Main(string[] args)
        {
            ResourceUtil.ExtractResource("LogConfig.xml", "LogConfig.xml", Assembly.GetAssembly(typeof(Program)));

            ByteSocket bs = new ByteSocket();

            bs.ConnectSuccessHandler += new ByteSocket.ConnectSocketDelegate(bs_ConnectSuccessHandler);

            bs.Connect("192.168.16.119", 20000);

            Console.ReadKey();
        }

        static void bs_ConnectSuccessHandler(ByteSocket bSock)
        {
            Console.WriteLine("客户端启动成功...");
            bSock.Sockets.Send(new byte[0]);
        }
    }
}
