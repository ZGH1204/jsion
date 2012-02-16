using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using log4net;
using System.Reflection;
using System.Collections.Specialized;

namespace GameBase.Managers
{
    public class ServerMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private readonly List<ServerConnector> m_servers = new List<ServerConnector>(10);

        private readonly HybridDictionary m_connected = new HybridDictionary();

        private readonly HybridDictionary m_connecting = new HybridDictionary();

        public void AddConnector(ServerConnector connector)
        {
            if (m_connected.Contains(connector.RemoteEndPoint)) return;

            m_connected.Add(connector.RemoteEndPoint, connector);

            m_connecting.Add(connector.Socket, connector);
        }

        public void RemoveConnector(ServerConnector connector)
        {
            if (m_connected.Contains(connector.RemoteEndPoint))
            {
                m_connected.Remove(connector.RemoteEndPoint);
            }

            if (m_servers.Contains(connector))
            {
                m_servers.Remove(connector);
            }
        }

        public void SuccessConnector(ServerConnector connector)
        {
            if (m_connecting.Contains(connector.Socket))
            {
                m_connecting.Remove(connector.Socket);

                m_servers.Add(connector);
            }
        }

        public void FaildConnector(ServerConnector connector)
        {
            if (m_connecting.Contains(connector.Socket))
            {
                m_connecting.Remove(connector.Socket);
            }

            if (m_connected.Contains(connector.RemoteEndPoint))
            {
                m_connected.Remove(connector.RemoteEndPoint);
            }
        }

        private static readonly ServerMgr m_instance = new ServerMgr();

        public static ServerMgr Instance { get { return m_instance; } }
    }
}
