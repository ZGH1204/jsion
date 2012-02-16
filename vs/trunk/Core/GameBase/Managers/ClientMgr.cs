using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.Specialized;

namespace GameBase.Managers
{
    public class ClientMgr
    {
        private static readonly HybridDictionary m_clients = new HybridDictionary();

        public static void AddClient(ClientBase client)
        {
            lock (m_clients.SyncRoot)
            {
                if (m_clients.Contains(client)) return;

                m_clients.Add(client, client);

                client.Disconnected += new DisconnectDelegate(client_Disconnected);
            }
        }

        static void client_Disconnected(ClientBase client)
        {
            RemoveClient(client);
        }

        public static void RemoveClient(ClientBase client)
        {
            lock (m_clients.SyncRoot)
            {
                if (m_clients.Contains(client))
                {
                    m_clients.Remove(client);
                }
            }
        }

        public static ClientBase[] GetAllClients()
        {
            ClientBase[] list;

            lock (m_clients.SyncRoot)
            {
                list = new ClientBase[m_clients.Count];

                m_clients.Keys.CopyTo(list, 0);
            }

            return list;
        }

        public static int ClientCount { get { return m_clients.Count; } }
    }
}
