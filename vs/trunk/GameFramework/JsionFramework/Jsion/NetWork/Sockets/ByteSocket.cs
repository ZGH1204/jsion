using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Sockets;
using NetWorkLib.Interfaces;
using System.Net;
using Jsion.Utils;
using log4net;
using System.Reflection;
using Jsion.NetWork.Packet;
using Jsion.NetWork.Processors;
using Jsion.Contants;
using JsionFramework.Jsion.Interfaces;

namespace Jsion.NetWork.Sockets
{
    public class ByteSocket : IDisposable
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        #region 事件

        public delegate void ReceivePkgDelegate(Package pkg);
        public delegate void AcceptSocketDelegate(Socket sock);
        public delegate void ConnectSocketDelegate(ByteSocket bSock);
        public delegate void DisconnectSocketDelegate();

        public event ReceivePkgDelegate ReceivePkgHandler;
        public event AcceptSocketDelegate AcceptSocketHandler;
        public event ConnectSocketDelegate ConnectSuccessHandler;
        public event ConnectSocketDelegate ConnectFailedHandler;
        public event DisconnectSocketDelegate DisconnectHandler;

        #endregion

        #region 公共属性

        public Socket Sockets { get { return _socket; } }

        public byte[] SendBuffer { get; set; }

        public byte[] ReceiveBuffer { get; set; }

        public bool EnableAsyncSend { get; set; }

        public ICrytPackage PackageCrytor { get; set; }

        public string RemoteEndPoint
        {
            get
            {
                if (Sockets != null && Sockets.Connected && Sockets.RemoteEndPoint != null)
                    return Sockets.RemoteEndPoint.ToString();

                return "Not connected!";
            }
        }

        #endregion

        #region 私有变量

        protected int port;
        protected string ip;
        protected Socket _socket;
        protected int m_hadTryTime;
        protected PackageProcessor _processor;
        protected SocketAsyncEventArgs acceptAsyncEvent;

        #endregion

        #region 只读配置属性(继承后配置)

        public virtual int SendBufferSize { get { return 2048; } }

        public virtual int ReceiveBufferSize { get { return 2048; } }

        public virtual Package ReceiveUsedPacket { get { return new Package(ReceiveBufferSize, EndianEnum.BIG_ENDIAN); } }

        public virtual bool Strict { get { return false; } }

        public virtual bool Encryted { get { return false; } }

        public virtual int CanTryTimes { get { return 3; } }

        public virtual ICrytPackage UsedCrytor { get { return null; } }

        #endregion

        #region 构造函数

        public ByteSocket(bool asyncSend = true)
        {
            EnableAsyncSend = asyncSend;
            PackageCrytor = UsedCrytor;
            SendBuffer = new byte[SendBufferSize];
            ReceiveBuffer = new byte[ReceiveBufferSize];
        }

        public ByteSocket(byte[] sBuffer, byte[] rBuffer, bool asyncSend = true)
        {
            EnableAsyncSend = asyncSend;
            PackageCrytor = UsedCrytor;
            SendBuffer = sBuffer;
            ReceiveBuffer = rBuffer;
        }

        #endregion

        #region 发起Socket连接


        public void Connect(string ip, int port)
        {
            if (!JsionUtils.IsIP(ip) || port <= 0)
            {
                log.ErrorFormat("The target host address is error.IP:{0}, Port:{1}", ip, port);
                return;
            }

            try
            {
                this.ip = ip;
                this.port = port;

                m_hadTryTime = 0;

                TryConnect(ip, port);
            }
            catch (Exception ex)
            {
                log.Error("连接失败.", ex);
            }
        }

        protected void TryConnect(string ip, int port)
        {
            _socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            SocketAsyncEventArgs connectAsyncEvent = new SocketAsyncEventArgs();
            IPAddress ipa = IPAddress.Parse(ip);
            IPEndPoint ep = new IPEndPoint(ipa, port);
            connectAsyncEvent.RemoteEndPoint = ep;
            connectAsyncEvent.Completed += new EventHandler<SocketAsyncEventArgs>(connectAsyncEvent_Completed);

            if (!_socket.ConnectAsync(connectAsyncEvent))
            {
                connectAsyncEvent_Completed(_socket, connectAsyncEvent);
            }
        }

        protected void connectAsyncEvent_Completed(object sender, SocketAsyncEventArgs e)
        {

            if (e.ConnectSocket != null)
            {
                InitProcessor();
                if(ConnectSuccessHandler != null) ConnectSuccessHandler(this);
            }
            else
            {
                if (CanTryTimes >= 0) m_hadTryTime++;

                if (m_hadTryTime > CanTryTimes)
                {
                    log.ErrorFormat("Connect ip: {0}, port: {1} failed.", ip, port);
                    if(ConnectFailedHandler != null) ConnectFailedHandler(this);
                }
                else
                {
                    log.WarnFormat("Try connect ip: {0}, port:{1} again. Current try times is {2}", ip, port, m_hadTryTime);
                    TryConnect(ip, port);
                }
            }
        }


        #endregion

        #region 初始化Accept到的Socket连接

        public virtual void Accept(Socket socket)
        {
            if (socket == null) return;

            this._socket = socket;
            InitProcessor();
        }

        protected void InitProcessor()
        {
            this._processor = new PackageProcessor(this, SendBuffer, ReceiveBuffer);
        }

        #endregion

        #region 初始化侦听本地终结点

        public bool ListenLocal(int port)
        {
            //IPAddress ip = NetWorkUtil.getLocalIPv4();
            //if (ip == null) return false;
            IPEndPoint endPoint = new IPEndPoint(IPAddress.Any, port);

            return Listen(endPoint);
        }

        private void acceptAsyncEvent_Completed(object sender, SocketAsyncEventArgs e)
        {
            Socket sock = null;
            try
            {
                //TODO 接收到Socket接入
                sock = e.AcceptSocket;
                try
                {
                    acceptSocketHandler(sock);
                }
                catch (Exception ex)
                {
                    log.Error("Accept socket event handler error.", ex);
                }
                acceptAsync(_socket, e);
            }
            catch
            {
                if (sock != null)
                {
                    try
                    {
                        sock.Close();
                    }
                    catch { }
                }
                Disconnect();
            }
        }

        protected void acceptSocketHandler(Socket sock)
        {
            AcceptSocketHandler(sock);
        }

        private bool Listen(IPEndPoint ip)
        {
            acceptAsyncEvent = new SocketAsyncEventArgs();
            acceptAsyncEvent.Completed += new EventHandler<SocketAsyncEventArgs>(acceptAsyncEvent_Completed);

            _socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.IP);
            try
            {
                _socket.Bind(ip);
                _socket.Listen(100);
                log.InfoFormat("建立本地监听 Port:{1}", ip.Address.ToString(), ip.Port.ToString());
            }
            catch (Exception ex)
            {
                log.Error("本地监听建立失败.", ex);
                return false;
            }
            acceptAsync(_socket, acceptAsyncEvent);
            return true;
        }

        private void acceptAsync(Socket sock, SocketAsyncEventArgs e)
        {
            e.AcceptSocket = null;

            if (sock.AcceptAsync(e) == false)
            {
                acceptAsyncEvent_Completed(e.AcceptSocket, e);
            }
        }

        #endregion

        #region 接收/发送数据包

        public void SendPkg(Package pkg)
        {
            if (_processor == null || pkg == null) return;

            _processor.SendTcp(pkg);
        }

        public void ReceivePkg(Package pkg)
        {
            if(ReceivePkgHandler != null) ReceivePkgHandler(pkg);
        }

        #endregion

        #region 关闭连接

        public virtual void Disconnect()
        {
            if (_socket != null)
            {
                if (_processor != null) _processor.ReleaseBuffer();
                _processor = null;

                try { _socket.Shutdown(SocketShutdown.Both); }
                catch { }

                try { _socket.Close(); }
                catch { }

                try { if (DisconnectHandler != null) DisconnectHandler(); }
                catch { }
            }
        }

        #endregion

        #region Dispose
        public void Dispose()
        {
            Disconnect();

            _socket = null;
            _processor = null;
            acceptAsyncEvent = null;
        }
        #endregion
    }
}
