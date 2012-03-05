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
        private static readonly ServerMgr<ServerConnector> m_instance = new ServerMgr<ServerConnector>();

        public static ServerMgr<ServerConnector> Instance { get { return m_instance; } }
    }

    public class ServerMgr<T> where T:ServerConnector
    {
        private readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private readonly List<T> m_servers = new List<T>(10);

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
            foreach (T connector in m_servers)
            {
                connector.SendTCP(pkg);
            }
        }

        public void SendToAllServer(GamePacket pkg, T except = null)
        {
            foreach (T connector in m_servers)
            {
                if (connector != except)
                {
                    connector.SendTCP(pkg);
                }
            }
        }

        public bool Contains(string ip, int port)
        {
            string str = ip + ":" + port.ToString();

            return m_connected.Contains(str);
        }

        public T GetConnector(string ip, int port)
        {
            string str = ip + ":" + port.ToString();

            if (m_connected.Contains(str))
            {
                return m_connected[str] as T;
            }

            return null;
        }

        public void AddConnector(T connector)
        {
            if (m_connected.Contains(connector.RemoteEndPoint)) return;

            m_connected.Add(connector.RemoteEndPoint, connector);

            m_connecting.Add(connector.Socket, connector);
        }

        public void RemoveConnector(T connector)
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

        public void SuccessConnector(T connector)
        {
            if (m_connecting.Contains(connector.Socket))
            {
                m_connecting.Remove(connector.Socket);

                m_servers.Add(connector);
            }
        }

        public void FaildConnector(T connector)
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

        public int ServerCount { get { return m_servers.Count; } }

    }
}
