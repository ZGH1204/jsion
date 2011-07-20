using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Threading;
using System.Configuration.Install;
using System.Reflection;
using System.Collections;
using System.ServiceProcess;

namespace GameServerService
{
    internal class Program
    {
        [MTAThread]
        private static void Main(string[] args)
        {

            AppDomain.CurrentDomain.SetupInformation.PrivateBinPath = "." + Path.DirectorySeparatorChar + "lib";

            Thread.CurrentThread.Name = "MAIN";


            AssemblyInstaller installer = new AssemblyInstaller(Assembly.GetExecutingAssembly(), null);

            Hashtable rollback = new Hashtable();

            try
            {
                //installer.Install(rollback);
                //installer.Commit(rollback);
                ////installer.Uninstall(rollback);
            }
            catch (Exception ex)
            {
                //installer.Rollback(rollback);
                Console.WriteLine("Error installing as system service");
                Console.WriteLine(ex.Message);
                //Console.ReadKey();
            }
            Console.ReadKey();
        }
    }
}
