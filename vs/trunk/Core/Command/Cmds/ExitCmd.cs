using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Command.Cmds
{
    [Cmd("Exit", "退出当前应用程序", "exit [-y]")]
    [CmdParam("-y", "不提示确认直接退出当前应用程序")]
    public class ExitCmd : ICommand
    {
        public bool Execute(string[] paramsList)
        {
            if (paramsList.Length == 0)
            {
                Console.Write("是否退出服务器？(y/n)");
                ConsoleKeyInfo cki = Console.ReadKey();

                if (cki.Key == ConsoleKey.Y)
                {
                    Environment.Exit(0);
                }
                else
                {
                    Console.WriteLine();
                }
            }
            else
            {
                string p = paramsList[0].ToLower();

                if (p == "-y")
                {
                    Environment.Exit(0);
                }
                else
                {
                    Console.WriteLine();
                }
            }

            return true;
        }
    }
}
