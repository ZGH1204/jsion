using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;

namespace JUtils
{
    /// <summary>
    /// 应用程序工具
    /// </summary>
    public class AppUtil
    {
        #region System Helpers

        /// <summary>
        /// 获取一个值,该值指示当前进程是否运行于64位的系统中
        /// </summary>
        public static bool IsRunningOn64Bit
        {
            get { return (IntPtr.Size == sizeof(long)); }
        }

        /// <summary>
        /// 获取一个值,该值指示当前操作系统是否为 Windows 2000或更高版本
        /// </summary>
        public static bool IsWindows2000OrNewer
        {
            get { return (Environment.OSVersion.Platform == PlatformID.Win32NT) && (Environment.OSVersion.Version.Major >= 5); }
        }

        /// <summary>
        /// 获取一个值,该值指示当前操作系统是否为 Windows XP或更高版本
        /// </summary>
        public static bool IsWindowsXpOrNewer
        {
            get
            {
                return
                    (Environment.OSVersion.Platform == PlatformID.Win32NT) &&
                    (
                        (Environment.OSVersion.Version.Major >= 6) ||
                        (
                            (Environment.OSVersion.Version.Major == 5) &&
                            (Environment.OSVersion.Version.Minor >= 1)
                        )
                    );
            }
        }

        /// <summary>
        /// 获取一个值,该值指示当前操作系统是否为 Windows Vista或更高版本
        /// </summary>
        public static bool IsWindowsVistaOrNewer
        {
            get { return (Environment.OSVersion.Platform == PlatformID.Win32NT) && (Environment.OSVersion.Version.Major >= 6); }
        }

        #endregion

        #region Application Exit Handling

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
