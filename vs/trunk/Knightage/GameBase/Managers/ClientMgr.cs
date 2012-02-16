using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.Specialized;

namespace GameBase.Managers
{
    public class ClientMgr
    {
        private readonly HybridDictionary m_clients = new HybridDictionary();

        public void AddClient(ClientBase client)
        {
            lock (m_clients.SyncRoot)
            {
                if (m_clients.Contains(client)) return;

                m_clients.Add(client, client);

                client.Disconnected += new DisconnectDelegate(client_Disconnected);
            }
        }

        void client_Disconnected(ClientBase client)
        {
            RemoveClient(client);
        }

        public void RemoveClient(ClientBase client)
        {
            lock (m_clients.SyncRoot)
            {
                if (m_clients.Contains(client))
                {
                    m_clients.Remove(client);
                }
            }
        }

        public ClientBase[] GetAllClients()
        {
            ClientBase[] list;

            lock (m_clients.SyncRoot)
            {
                list = new ClientBase[m_clients.Count];

                m_clients.Keys.CopyTo(list, 0);
            }

            return list;
        }

        public int ClientCount { get { return m_clients.Count; } }


        private static readonly ClientMgr m_instance = new ClientMgr();

        public static ClientMgr Instance { get { return m_instance; } }
    }
}
