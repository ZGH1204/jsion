using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JUtils.Messages;
using JUtils.Attributes;
using JUtils.Net;

namespace NetWork
{
    public class GameConnecter : DefaultReceiver
    {
        private JSocket m_socket;

        public GameConnecter(string id)
            : base(id)
        { }

        [MsgHandler(NetMsg.SetSocketType, false, "设置Socket类型")]
        public object SetSocketType(Message msg)
        {
            Type type = msg.WParam as Type;
            if (type == null)
            {
                throw new ArgumentException("msg.WParam 参数必需为类的Type对象");
            }

            m_socket = type.Assembly.CreateInstance(type.FullName) as JSocket;

            if (m_socket == null)
            {
                throw new ArgumentException("msg.WParam 参数必需为继续JSocket的类的Type对象");
            }

            return null;
        }

        [MsgHandler(NetMsg.Connect, false, "连接到指定主机")]
        public object Connect(Message msg)
        {
            if (m_socket == null)
            {
                throw new Exception("请先通过 NetMsg.SetSocketType 消息创建Socket");
            }

            string ip = msg.WParam as string;
            int port = (int)msg.LParam;

            m_socket.ConnectedSuccess += new ConnectSocketDelegate(m_socket_ConnectedSuccess);
            m_socket.ConnectedFaild += new ConnectSocketDelegate(m_socket_ConnectedFaild);
            m_socket.Disconnected += new DisconnectSocketDelegate(m_socket_Disconnected);
            m_socket.Received += new ReceivePacketDelegate(m_socket_Received);

            m_socket.Connect(ip, port);

            return null;
        }

        void m_socket_Received(Packet packet)
        {
            CreateAndSendMsg(NetMsg.Received, null, packet);
        }

        void m_socket_Disconnected()
        {
            CreateAndSendMsg(NetMsg.Disconnected);
        }

        void m_socket_ConnectedFaild(JSocket socket)
        {
            CreateAndSendMsg(NetMsg.Errored, null, socket);
        }

        void m_socket_ConnectedSuccess(JSocket socket)
        {
            CreateAndSendMsg(NetMsg.Connected, null, socket);
        }
    }
}
