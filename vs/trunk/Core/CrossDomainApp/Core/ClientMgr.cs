using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Sockets;

namespace CrossDomainApp.Core
{
    public class ClientMgr
    {
        private Dictionary<Socket, CrossFileClient> m_list;

        private readonly object m_locker = new object();

        private ClientMgr()
        {
            m_list = new Dictionary<Socket, CrossFileClient>();
        }

        public void Add(CrossFileClient client)
        {
            if (client == null || client.Socket == null) return;

            lock (m_locker)
            {
                if (m_list.ContainsKey(client.Socket))
                {
                    m_list.Add(client.Socket, client);

                    client.DisconnectSocket += new DisconnectSocketDelegate(client_DisconnectSocket);
                }
            }
        }

        void client_DisconnectSocket(Socket socket)
        {
            lock (m_locker)
            {
                m_list.Remove(socket);
            }
        }

        public bool Remove(CrossFileClient client)
        {
            if (client == null || client.Socket == null) return false;

            lock (m_locker)
            {
                return m_list.Remove(client.Socket);
            }
        }

        public static readonly ClientMgr m_instance = new ClientMgr();

        public static ClientMgr Instance
        {
            get { return m_instance; }
        }
    }
}
