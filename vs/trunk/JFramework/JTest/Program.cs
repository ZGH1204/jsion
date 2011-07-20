using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JCore;

namespace JTest
{
    class Program
    {
        static JLauncher launcher;
        static void Main(string[] args)
        {
            launcher = new JLauncher();

            launcher.Startup();
        }
    }
}
