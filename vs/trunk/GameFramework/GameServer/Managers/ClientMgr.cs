using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.Specialized;

namespace GameServer.Managers
{
    public class ClientMgr
    {
        private static readonly HybridDictionary m_clients = new HybridDictionary();

        public static void AddClient(GameClient client)
        {
            lock (m_clients.SyncRoot)
            {
                if (m_clients.Contains(client)) return;
                m_clients.Add(client, client);
            }
        }

        public static void RemoveClient(GameClient client)
        {
            lock (m_clients.SyncRoot)
            {
                if (m_clients.Contains(client) == false) return;
                m_clients.Remove(client);
            }
        }

        public static int ClientCount
        {
            get { return m_clients.Count; }
        }

        public static GameClient[] GetAllClient()
        {
            GameClient[] list = null;
            lock (m_clients.SyncRoot)
            {
                list = new GameClient[m_clients.Count];
                m_clients.Keys.CopyTo(list, 0);
            }
            return list;
        }
    }
}
