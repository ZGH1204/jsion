using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.Specialized;

namespace FightServer.Managers
{
    public class GameServerMgr
    {
        private static readonly HybridDictionary m_servers = new HybridDictionary();

        public static void AddClient(ServerClient client)
        {
            lock (m_servers.SyncRoot)
            {
                if (m_servers.Contains(client)) return;
                m_servers.Add(client, client);
            }
        }

        public static void RemoveClient(ServerClient client)
        {
            lock (m_servers.SyncRoot)
            {
                if (m_servers.Contains(client) == false) return;
                m_servers.Remove(client);
            }
        }

        public static ServerClient[] GetAllClient()
        {
            ServerClient[] list = null;
            lock (m_servers.SyncRoot)
            {
                list = new ServerClient[m_servers.Count];
                m_servers.Keys.CopyTo(list, 0);
            }
            return list;
        }

        public static int GetClientCount()
        {
            return m_servers.Count;
        }
    }
}
