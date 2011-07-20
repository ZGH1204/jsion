using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Sockets;
using Jsion;
using FightServer.Managers;
using ServerCommon.Jsion.Server;
using ServerCommon.Jsion.Client;

namespace FightServer
{
    public class FSServer : ServerBase
    {
        protected override ClientBase CreateClient(Socket sock)
        {
            return new ServerClient(sock, BufferMgr.AcquireBuffer(), BufferMgr.AcquireBuffer());
        }

        protected override void SaveClient(ClientBase client)
        {
            ServerClient sClient = client as ServerClient;

            GameServerMgr.AddClient(sClient);

            sClient.ClientDisconnectHandler += new ClientBase.ClientDisconnectedDelegate(cClient_ClientDisconnectHandler);
        }

        private void cClient_ClientDisconnectHandler(ClientBase client)
        {
            ServerClient sClient = client as ServerClient;

            sClient.ClientDisconnectHandler -= new ClientBase.ClientDisconnectedDelegate(cClient_ClientDisconnectHandler);

            GameServerMgr.RemoveClient(sClient);

            if (sClient.Socket != null)
            {
                byte[] temp = sClient.Socket.SendBuffer;
                sClient.Socket.SendBuffer = null;
                BufferMgr.ReleaseBuffer(temp);

                temp = sClient.Socket.ReceiveBuffer;
                sClient.Socket.ReceiveBuffer = null;
                BufferMgr.ReleaseBuffer(temp);
            }
        }

        private static FSServer m_instance;
        public static FSServer Instance
        {
            get
            {
                if (m_instance == null)
                {
                    m_instance = new FSServer();
                }

                return m_instance;
            }
        }
    }
}
