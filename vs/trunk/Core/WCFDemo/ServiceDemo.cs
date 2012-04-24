using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using WCFDemo.Services;

namespace WCFDemo
{
    public class ServiceDemo : IWebService
    {
        public void SayHello(string name)
        {
            Console.WriteLine("Hello, " + name);
        }


        public void AddTeam(ServiceData data)
        {
            
        }
    }
}
