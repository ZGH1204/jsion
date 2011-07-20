using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JsionFramework.Jsion.Managers;
using System.Runtime.InteropServices;
using System.Diagnostics;
using System.Threading;

namespace ServerCommon.Jsion.Managers
{
    public abstract class ServerMgr
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


        private static bool m_successed = false;

        public static bool Successed
        {
            get { return m_successed; }
        }

        public static void Success()
        {
            m_successed = true;
        }

        public static void Failed()
        {
            m_successed = false;
        }

        public static void PressKeyExit()
        {
            Console.WriteLine();
            Console.Write("按任意键退出..");
            Console.ReadKey();
        }

        public static void DisabledCloseBtn()
        {
            Process p = Process.GetCurrentProcess();

            //找关闭按钮
            IntPtr CLOSE_MENU = GetSystemMenu(p.MainWindowHandle, IntPtr.Zero);

            //关闭按钮禁用
            RemoveMenu(CLOSE_MENU, SC_CLOSE, 0x0);
        }

        public static void WaitingInputCmd(string prex)
        {
            Thread.Sleep(5000);

            Console.WriteLine("回车后可输入指令!\r\n");

            while (true)
            {
                ConsoleKeyInfo key = Console.ReadKey(false);

                if (key.Key == ConsoleKey.Enter)
                {
                    Console.Write(prex + ">");
                    string cmd = Console.ReadLine();
                    CommandMgr.Instance.ExecuteCommand(cmd);
                }
                //Console.WriteLine();
            }
        }
    }
}
