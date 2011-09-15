using System;
using System.Collections.Generic;
using System.Reflection;
using log4net;

namespace Command
{
    public sealed class CommandMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private Dictionary<string, ICommand> CommandsList = new Dictionary<string, ICommand>();
        private Dictionary<string, string> DescriptionsList = new Dictionary<string, string>();

        private CommandMgr() { }

        public bool ExecuteCommand(string cmd)
        {
            if (string.IsNullOrEmpty(cmd)) return false;

            string cmdStr = cmd.Split(new string[] { " " }, StringSplitOptions.RemoveEmptyEntries)[0].Trim().ToLower();

            if (string.IsNullOrEmpty(cmdStr))
            {
                log.Error("The command is not empty.");
                return false;
            }

            if (CommandsList.ContainsKey(cmdStr) == false)
            {
                log.ErrorFormat("The command of '{0}' is not exists.", cmdStr);
                return false;
            }

            ICommand command = CommandsList[cmdStr];

            int paramStartIndex = cmd.IndexOf(" ");

            string[] paramsList = null;

            if (paramStartIndex != -1)
            {
                string tmp = cmd.Substring(paramStartIndex).Trim();
                //if (!string.IsNullOrEmpty(tmp)) tmp = " " + tmp;
                paramsList = tmp.Split(new string[] { "-" }, StringSplitOptions.RemoveEmptyEntries);
            }
            else
            {
                paramsList = new string[0];
            }

            if (paramsList.Length > 0 && paramsList[0] == "/?")
            {
                DisplayDescription(cmdStr);
                return true;
            }

            for (int i = 0; i < paramsList.Length; i++)
            {
                paramsList[i] = paramsList[i].Trim();
                paramsList[i] = "-" + paramsList[i];
            }

            try
            {
                return command.Execute(paramsList);
            }
            catch (Exception ex)
            {
                log.Error(string.Format("The command of '{0}' execute failed.", cmdStr), ex);
                return false;
            }
        }

        public void DisplayCommandList()
        {
            WriteLine(0, "命令列表：", 0, "");

            string[] keyList = new string[CommandsList.Keys.Count];

            CommandsList.Keys.CopyTo(keyList, 0);

            foreach (string cmd in keyList)
            {
                ICommand command = CommandsList[cmd];

                object[] attrs = command.GetType().GetCustomAttributes(typeof(CmdAttribute), false);

                if (attrs.Length == 0) continue;

                CmdAttribute ca = attrs[0] as CmdAttribute;

                WriteLine(4, ca.Cmd, 20, ca.Description);
            }
            Console.WriteLine();
        }

        public void DisplayDescription(string cmd)
        {
            if (string.IsNullOrEmpty(cmd)) return;

            cmd = cmd.ToLower();

            if (CommandsList.ContainsKey(cmd) == false)
            {
                log.ErrorFormat("The command of '{0}' is not exists.", cmd);
                return;
            }

            ICommand command = CommandsList[cmd];

            object[] attrs = command.GetType().GetCustomAttributes(typeof(CmdAttribute), false);

            if (attrs.Length > 0)
            {
                CmdAttribute ca = attrs[0] as CmdAttribute;

                if (!string.IsNullOrEmpty(ca.Description))
                {
                    WriteLine(0, ca.Cmd + ": ", ca.Cmd.Length + 2, ca.Description);
                }

                if (!string.IsNullOrEmpty(ca.Usage))
                {
                    WriteLine(0, "用法：", 0, ca.Usage + "\r\n");
                }
            }

            attrs = command.GetType().GetCustomAttributes(typeof(CmdParamAttribute), false);

            WriteLine(4, "/?", 10, "显示帮助信息");

            for (int i = 0; i < attrs.Length; i++)
            {
                CmdParamAttribute cpa = attrs[i] as CmdParamAttribute;
                WriteLine(4, cpa.Key, 10, cpa.Description);
            }
            Console.WriteLine();
        }

        public static void WriteLine(int preSpace, string param, int paramPlace, string description)
        {
            for (int i = 0; i < preSpace; i++)
            {
                Console.Write(" ");
            }

            Console.Write(param);

            int rlt = paramPlace - param.Length;
            if (rlt > 0)
            {
                for (int i = 0; i < rlt; i++)
                {
                    Console.Write(" ");
                }
            }
            else
            {
                Console.Write(" ");
            }

            Console.WriteLine(description);
        }

        public static string GetParam(string param, string[] paramsList)
        {
            if (paramsList.Length == 0)
            {
                return null;
            }

            for (int i = 0; i < paramsList.Length; i++)
            {
                if (paramsList[i].StartsWith(param))
                {
                    return paramsList[i];
                }
            }

            return null;
        }

        #region CommandList

        public int SearchCommand(Assembly ass)
        {
            ClearCommand();

            CombinCommonCommand();

            return CombinCommand(ass, true);
        }

        public void ClearCommand()
        {
            CommandsList.Clear();
            CombinCommonCommand();
        }

        public int CombinCommonCommand()
        {
            if (!CommandsList.ContainsKey("help"))
            {
                return CombinCommand(Assembly.GetAssembly(typeof(CommandMgr)), true);
            }

            return 0;
        }

        public int CombinCommand(Assembly ass, bool replaceExists)
        {
            int count = 0;

            Type[] tList = ass.GetTypes();

            string interfaceStr = typeof(ICommand).ToString();

            foreach (Type type in tList)
            {
                if (type.IsClass != true) continue;

                if (type.GetInterface(interfaceStr) == null) continue;

                CmdAttribute[] atts = (CmdAttribute[])type.GetCustomAttributes(typeof(CmdAttribute), true);

                if (atts.Length > 0)
                {
                    count++;

                    if (replaceExists == false && CommandsList.ContainsKey(atts[0].Cmd))
                    {
                        log.ErrorFormat("The command of '{0}' is exists, command's description is {1}", atts[0].Cmd, atts[0].Description);
                    }
                    else
                    {
                        if (replaceExists == true && CommandsList.ContainsKey(atts[0].Cmd))
                        {
                            log.WarnFormat("The command of '{0}' has been replaced! Description: {1}", atts[0].Cmd, DescriptionsList[atts[0].Cmd]);
                        }

                        CommandsList[atts[0].Cmd.ToLower()] = (ICommand)Activator.CreateInstance(type);
                        DescriptionsList[atts[0].Cmd.ToLower()] = atts[0].Description;
                    }
                }
            }

            return count;
        }

        #endregion

        #region 单件模式

        private static CommandMgr m_instance;
        private static readonly object m_syncRoot = new object();

        public static CommandMgr Instance
        {
            get
            {
                if (m_instance == null)
                {
                    lock (m_syncRoot)
                    {
                        if (m_instance == null)
                        {
                            m_instance = new CommandMgr();
                        }
                    }
                }

                return m_instance;
            }
        }

        #endregion
    }
}
