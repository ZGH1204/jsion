using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using log4net;
using System.Reflection;

namespace GameServer.Managers
{
    public class FightServerMgr
    {
        public static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected static IList<FightServer> m_list = new List<FightServer>();

        public static void ConnectFightServers()
        {
            string[] list = GSConfigMgr.Configuration.BattleServerList.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);

            if (list.Length == 0 || string.IsNullOrEmpty(list[0]))
            {
                log.Error("未配置战斗服务器!");
                return;
            }

            foreach (string str in list)
            {
                string[] address = str.Split(new string[] { ":" }, StringSplitOptions.RemoveEmptyEntries);

                if (address.Length < 2)
                {
                    log.Error("战斗服务器配置错误!");
                    return;
                }

                FightServer server = new FightServer("战斗服务器(" + str + ")");

                server.Connect(address[0], int.Parse(address[1]));
            }
        }

        public static void AddServer(FightServer server)
        {
            if (!m_list.Contains(server))
            {
                m_list.Add(server);
            }
        }

        public static void RemoveServer(FightServer server)
        {
            if (m_list.Contains(server))
            {
                m_list.Remove(server);
            }
        }

        public static bool HasServer
        {
            get { return (m_list.Count != 0); }
        }

        private static readonly object LockHelper = new object();
        public static FightServer AcquireServer()
        {
            lock (LockHelper)
            {
                if (!HasServer) return null;

                FightServer server = m_list[0];
                if (m_list.Count > 1)
                {
                    m_list.RemoveAt(0);
                    m_list.Add(server);
                }
                return server;
            }
        }

        public static FightServer[] GetAllFightServer()
        {
            FightServer[] list = new FightServer[m_list.Count];

            m_list.CopyTo(list, 0);

            return list;
        }
    }
}
