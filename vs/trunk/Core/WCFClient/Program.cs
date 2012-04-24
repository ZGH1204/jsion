using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using WCFClient.ServiceReference1;

namespace WCFClient
{
    class Program
    {
        static void Main(string[] args)
        {
            WebServiceClient client = new WebServiceClient();

            client.SayHello("dfdfdf");
            client.SayHello("Jsion");
        }
    }
}
