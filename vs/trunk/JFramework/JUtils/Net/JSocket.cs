using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Sockets;
using System.Net;
using log4net;
using System.Reflection;

namespace JUtils.Net
{
    public class JSocket
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        #region 事件

        public event AcceptSocketDelegate AcceptedSocket;
        public event DisconnectSocketDelegate Disconnected;

        public event ConnectSocketDelegate ConnectedSuccess;
        public event ConnectSocketDelegate ConnectedFaild;
        public event ReceivePacketDelegate Received;

        #endregion

        #region 属性/变量

        public bool EnableAsyncSend { get; set; }

        public int CanTryTimes { get; set; }

        public int HadTryTimes { get; internal set; }

        public byte[] SendBuffer { get; protected set; }

        public byte[] ReceiveBuffer { get; protected set; }

        public string IP { get; internal set; }

        public int Port { get; internal set; }

        public Socket Socket { get; internal set; }

        public string RemoteEndPoint
        {
            get
            {
                if (Socket != null && Socket.Connected && Socket.RemoteEndPoint != null)
                    return Socket.RemoteEndPoint.ToString();

                return "Not connected!";
            }
        }

        private SocketAsyncEventArgs m_acceptAsyncEvent;

        private SocketConnecter m_connecter;
        private SocketAccepter m_accepter;

        private PacketSender m_sender;
        private PacketReader m_reader;

        #endregion

        #region 配置项

        public virtual Packet UsedPacket { get { return new Packet(); } }
        public virtual IPacketCryptor SendCryptor { get { return new PacketCryptor(); } }
        public virtual IPacketCryptor ReceiveCryptor { get { return new PacketCryptor(); } }

        #endregion

        #region 构造函数

        public JSocket()
            : this(new byte[2048], new byte[2048])
        { }

        public JSocket(byte[] sBuffer, byte[] rBuffer)
        {
            EnableAsyncSend = true;

            HadTryTimes = 0;
            CanTryTimes = 3;

            SendBuffer = sBuffer;
            ReceiveBuffer = rBuffer;

            m_sender = new PacketSender(this, SendBuffer);
            m_reader = new PacketReader(this, ReceiveBuffer);
        }

        #endregion

        #region 侦听本地端口

        public void ListenLocal(int port)
        {
            m_accepter = new SocketAccepter(this);
            m_accepter.ListenLocal(port);
        }

        internal void ListenAcceptSocket(Socket socket)
        {
            try
            {
                if (AcceptedSocket != null && socket != null)
                {
                    AcceptedSocket(socket);
                }
            }
            catch (Exception ex)
            {
                log.Error("客户端连接事件处理错误.", ex);
            }
        }

        #endregion

        #region 连接指定Socket

        public void Connect(string ip, int port)
        {
            m_connecter = new SocketConnecter(this);
            m_connecter.Connect(ip, port);
        }

        internal void ConnectedSuccessed()
        {
            if (ConnectedSuccess == null) return;
            ConnectedSuccess(this);
        }

        internal void ConnectedFailded()
        {
            if (ConnectedFaild == null) return;
            ConnectedFaild(this);
        }

        #endregion

        #region 保存Socket连接

        public virtual void Accept(Socket socket)
        {
            if (socket == null) return;

            Socket = socket;
        }

        #endregion

        #region 发送/接收

        public void SendPacket(Packet pkg)
        {
            m_sender.SendTcp(pkg);
        }

        internal void ReceivePkg(Packet pkg)
        {
            try
            {
                if (Received == null) return;
                Received(pkg);
            }
            catch (Exception ex)
            {
                log.Error("数据包处理出错.", ex);
            }
        }

        #endregion

        #region 关闭侦听

        public virtual void Disconnect()
        {
            if (Socket != null)
            {
                //m_sender = null;
                //m_reader = null;

                try { Socket.Shutdown(SocketShutdown.Both); }
                catch { }

                try { Socket.Close(); }
                catch { }

                try { if (Disconnected != null) Disconnected(); }
                catch { }

                Socket = null;
            }
        }

        #endregion
    }
}
