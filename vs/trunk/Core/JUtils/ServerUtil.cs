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

        /// <summary>
        /// 查看：http://geekswithblogs.net/mrnat/archive/2004/09/23/11594.aspx
        /// </summary>
        /// <param name="consoleCtrlHandler"></param>
        /// <param name="Add"></param>
        /// <returns></returns>
        [DllImport("Kernel32")]
        public static extern bool SetConsoleCtrlHandler(ConsoleCtrlHandler consoleCtrlHandler, bool Add);

        /// <summary>
        /// 查看:SetConsoleCtrlHandler
        /// </summary>
        /// <param name="CtrlType"></param>
        /// <returns></returns>
        public delegate bool ConsoleCtrlHandler(CtrlTypes CtrlType);

        /// <summary>
        /// 查看:SetConsoleCtrlHandler
        /// </summary>
        public enum CtrlTypes
        {
            CTRL_C_EVENT = 0,
            CTRL_BREAK_EVENT,
            CTRL_CLOSE_EVENT,
            CTRL_LOGOFF_EVENT = 5,
            CTRL_SHUTDOWN_EVENT
        }

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

        #region Application Exit Handling

        static readonly List<ConsoleCtrlHandler> ctrlHandlers = new List<ConsoleCtrlHandler>();
        static readonly List<EventHandler> processHooks = new List<EventHandler>();

        /// <summary>
        /// 取消所有已添加的系统钩子
        /// </summary>
        public static void UnhookAll()
        {
            foreach (var hook in ctrlHandlers)
            {
                SetConsoleCtrlHandler(hook, false);
            }

            foreach (var hook in processHooks)
            {
                AppDomain.CurrentDomain.ProcessExit -= hook;
            }

            ctrlHandlers.Clear();
            processHooks.Clear();
        }

        /// <summary>
        /// 添加一个方法,该方法在应用程序退出时将被执行
        /// </summary>
        /// <param name="action"></param>
        public static void AddApplicationExitHandler(Action action)
        {
            EventHandler evtHandler = (sender, evt) => action();
            processHooks.Add(evtHandler);

            AppDomain.CurrentDomain.ProcessExit += evtHandler;

            ConsoleCtrlHandler ctrlConsoleCtrlHandler = type =>
            {
                action();
                return false;
            };
            ctrlHandlers.Add(ctrlConsoleCtrlHandler);

            SetConsoleCtrlHandler(ctrlConsoleCtrlHandler, true);


        }

        #endregion
    }
}
