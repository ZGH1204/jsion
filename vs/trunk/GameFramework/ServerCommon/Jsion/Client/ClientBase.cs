using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Sockets;
using log4net;
using System.Reflection;
using Jsion.NetWork.Packet;

namespace ServerCommon.Jsion.Client
{
    public class ClientBase
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public delegate void ClientDisconnectedDelegate(ClientBase client);

        public event ClientDisconnectedDelegate ClientDisconnectHandler;

        protected SSocket m_socket = null;

        public SSocket Socket
        {
            get
            {
                return m_socket;
            }
        }

        public ClientBase()
        {
            Init();
        }

        public ClientBase(Socket socket)
        {
            Init();
            Accept(socket);
        }

        public ClientBase(Socket socket, byte[] sBuffer, byte[] rBuffer)
        {
            Init();
            Accept(socket, sBuffer, rBuffer);
        }

        protected virtual void Init()
        {
            
        }

        public void Accept(Socket socket)
        {
            if (m_socket != null) return;
            m_socket = new SSocket();
            m_socket.Accept(socket);
            m_socket.DisconnectHandler += new SSocket.DisconnectSocketDelegate(OnDisconnectSocket);
            m_socket.ReceivePkgHandler += new SSocket.ReceivePkgDelegate(OnReceivePackage);
        }

        public void Accept(Socket socket, byte[] sBuffer, byte[] rBuffer)
        {
            if (m_socket != null) return;
            m_socket = new SSocket(sBuffer, rBuffer);
            m_socket.Accept(socket);
            m_socket.DisconnectHandler += new SSocket.DisconnectSocketDelegate(OnDisconnectSocket);
            m_socket.ReceivePkgHandler += new SSocket.ReceivePkgDelegate(OnReceivePackage);
        }

        protected virtual void OnDisconnectSocket()
        {
            if (ClientDisconnectHandler != null)
            {
                ClientDisconnectHandler(this);
            }
        }

        public void SendTcp(Package pkg)
        {
            if (m_socket == null) return;

            m_socket.SendPkg(pkg);
        }

        protected virtual void OnReceivePackage(Package pkg)
        {
            throw new NotImplementedException();
        }
    }
}
