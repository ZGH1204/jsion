using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.Specialized;

namespace GameBase.Managers
{
    public class ClientMgr
    {
        private static readonly ClientMgr<ClientBase> m_instance = new ClientMgr<ClientBase>();

        public static ClientMgr<ClientBase> Instance { get { return m_instance; } }
    }

    public class ClientMgr<T> where T:ClientBase
    {
        private readonly HybridDictionary m_clients = new HybridDictionary();

        public void AddClient(T client)
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
            RemoveClient(client as T);
        }

        public void RemoveClient(T client)
        {
            lock (m_clients.SyncRoot)
            {
                if (m_clients.Contains(client))
                {
                    m_clients.Remove(client);
                }
            }
        }

        public T[] GetAllClients()
        {
            T[] list;

            lock (m_clients.SyncRoot)
            {
                list = new T[m_clients.Count];

                m_clients.Keys.CopyTo(list, 0);
            }

            return list;
        }

        public int ClientCount { get { return m_clients.Count; } }
    }
}
