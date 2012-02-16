using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using log4net;
using System.Reflection;
using System.Collections.Specialized;
using GameBase.Net;

namespace GameBase.Managers
{
    public class ServerMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private readonly List<ServerConnector> m_servers = new List<ServerConnector>(10);

        private readonly HybridDictionary m_connected = new HybridDictionary();

        private readonly HybridDictionary m_connecting = new HybridDictionary();

        private int m_index = -1;

        public void SendToServer(GamePacket pkg)
        {
            if (m_servers.Count > 0)
            {
                m_index++;

                if (m_index >= m_servers.Count)
                {
                    m_index = 0;
                }

                m_servers[m_index].SendTCP(pkg);
            }
        }

        public void SendToAllServer(GamePacket pkg)
        {
            foreach (ServerConnector connector in m_servers)
            {
                connector.SendTCP(pkg);
            }
        }

        public void SendToAllServer(GamePacket pkg, ServerConnector except)
        {
            foreach (ServerConnector connector in m_servers)
            {
                if (connector != except)
                {
                    connector.SendTCP(pkg);
                }
            }
        }

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
