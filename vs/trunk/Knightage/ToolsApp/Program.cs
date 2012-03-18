using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Tools;
using System.Reflection;

namespace ToolsApp
{
    class Program
    {
        static void Main(string[] args)
        {
            //PlayerInfo info = new PlayerInfo();

            Type type = typeof(PlayerInfo);

            FieldInfo[] fileds = type.GetFields();

            PropertyInfo[] pis = type.GetProperties();

            Console.ReadKey();
        }
    }
}
