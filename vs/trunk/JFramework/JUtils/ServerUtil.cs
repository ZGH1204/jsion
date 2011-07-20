using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Diagnostics;
using System.Reflection;

namespace JUtils
{
    public class ServerUtil
    {
        #region 引入Windows的API

        public const int SC_CLOSE = 0xF060;
        //public const int SC_MINIMIZE = 0xF020;
        //public const int SC_MAXIMIZE = 0xF030;

        //[DllImport("User32.dll ", EntryPoint = "FindWindow")]
        //private static extern int FindWindow(string lpClassName, string lpWindowName);
        [DllImport("user32.dll ", EntryPoint = "GetSystemMenu")]
        private extern static IntPtr GetSystemMenu(IntPtr hWnd, IntPtr bRevert);
        [DllImport("user32.dll ", EntryPoint = "RemoveMenu")]
        private extern static int RemoveMenu(IntPtr hMenu, int nPos, int flags);

        #endregion

        /// <summary>
        /// 导出log4net的日志配置文件
        /// </summary>
        public static void ExportLogConfig()
        {
            ResourceUtil.ExtractResourceSafe("LogConfig.xml", "LogConfig.xml", Assembly.GetAssembly(typeof(ServerUtil)));
        }

        /// <summary>
        /// 禁用窗口的关闭按钮
        /// </summary>
        public static void DisabledCloseBtn()
        {
            Process p = Process.GetCurrentProcess();

            //找关闭按钮
            IntPtr CLOSE_MENU = GetSystemMenu(p.MainWindowHandle, IntPtr.Zero);

            //关闭按钮禁用
            RemoveMenu(CLOSE_MENU, SC_CLOSE, 0x0);
        }

        /// <summary>
        /// 按任意键退出
        /// </summary>
        public static void PressKeyExit()
        {
            Console.WriteLine();
            Console.Write("按任意键退出..");
            Console.ReadKey();
        }
        public delegate void CmdHandler(string cmd);

        public static event CmdHandler ReceiveCmdEvent;
        /// <summary>
        /// 等待输入命令
        /// </summary>
        /// <param name="prex"></param>
        public static void WaitingCmd(string prex)
        {
            //Console.Write("回车后可输入指令!");

            while (true)
            {
                //ConsoleKeyInfo key = Console.ReadKey(false);

                //if (key.Key == ConsoleKey.Enter)
                //{
                    Console.Write("\r\n" + prex + ">");
                    string cmd = Console.ReadLine();

                    if (cmd.IsNullOrEmpty()) continue;

                    if (ReceiveCmdEvent != null)
                        ReceiveCmdEvent(cmd);

                    if (cmd == "shutdown") Environment.Exit(0);
                //}
            }
        }
    }
}
