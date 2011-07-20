using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JUtils.Messages;
using JUtils.Net;
using JUtils.Attributes;

namespace NetWork
{
    public class GameListener : DefaultReceiver
    {
        private int m_port;

        private JSocket m_socket;

        //private Type m_type;

        public GameListener(string id)
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

        [MsgHandler(NetMsg.Listen, false, "监听本地端口")]
        public object Listen(Message msg)
        {
            if (m_socket == null)
            {
                throw new Exception("请先通过NetMsg.SetSocketType消息创建Socket");
            }

            m_port = (int)msg.WParam;

            m_socket.AcceptedSocket += new AcceptSocketDelegate(m_socket_AcceptedSocket);
            m_socket.Disconnected += new DisconnectSocketDelegate(m_socket_Disconnected);

            m_socket.ListenLocal(m_port);

            return null;
        }

        [MsgHandler(NetMsg.Close, false, "")]
        public object Close(Message msg)
        {
            if (m_socket == null) return null;

            m_socket.AcceptedSocket -= m_socket_AcceptedSocket;
            m_socket.Disconnected -= m_socket_Disconnected;

            m_socket.Disconnect();

            return null;
        }

        void m_socket_Disconnected()
        {
            CreateAndSendMsg(NetMsg.Disconnected);
        }

        void m_socket_AcceptedSocket(System.Net.Sockets.Socket socket)
        {
            CreateAndSendMsg(NetMsg.Accepted, null, socket);
        }
    }
}
