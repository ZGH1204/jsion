using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ServerCommon.Jsion.Server;
using ServerCommon.Jsion.Client;
using System.Net.Sockets;
using GameServer.Managers;
using Jsion;

namespace GameServer
{
    public class GSServer : ServerBase
    {
        protected override ClientBase CreateClient(Socket sock)
        {
            return new GameClient(sock, BufferMgr.AcquireBuffer(), BufferMgr.AcquireBuffer());
        }

        protected override void SaveClient(ClientBase client)
        {
            GameClient gClient = client as GameClient;

            ClientMgr.AddClient(gClient);

            gClient.ClientDisconnectHandler += new ClientBase.ClientDisconnectedDelegate(gClient_ClientDisconnectHandler);
        }

        void gClient_ClientDisconnectHandler(ClientBase client)
        {
            GameClient gClient = client as GameClient;

            gClient.ClientDisconnectHandler -= new ClientBase.ClientDisconnectedDelegate(gClient_ClientDisconnectHandler);

            ClientMgr.RemoveClient(gClient);

            if (gClient.Socket != null)
            {
                byte[] temp = gClient.Socket.SendBuffer;
                gClient.Socket.SendBuffer = null;
                BufferMgr.ReleaseBuffer(temp);

                temp = gClient.Socket.ReceiveBuffer;
                gClient.Socket.ReceiveBuffer = null;
                BufferMgr.ReleaseBuffer(temp);
            }
        }

        #region 单件

        private static GSServer _instance;
        //private static readonly object m_syncRoot = new object();
        public static GSServer Instance
        {
            get
            {
                if (_instance == null)
                {
                    _instance = new GSServer();
                    //lock (m_syncRoot)
                    //{
                    //    if (_instance == null)
                    //    {
                    //        _instance = new GSServer();
                    //    }
                    //}
                }

                return _instance;
            }
        }

        #endregion
    }
}
