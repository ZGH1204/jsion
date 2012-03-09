using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Sockets;
using System.Reflection;

namespace CrossDomainApp.Core
{
    public class CrossFileClient
    {
        public event DisconnectSocketDelegate DisconnectSocket;

        public string IP { get; protected set; }

        public int Port { get; protected set; }

        public Socket Socket { get; protected set; }

        private SocketAsyncEventArgs m_receiveAsyncEvent;

        private byte[] m_buffer;

        public CrossFileClient(Socket socket)
        {
            if (socket == null) return;

            m_buffer = new byte[32];

            Socket = socket;

            IP = socket.RemoteEndPoint.ToString().Split(':')[0];
            Port = int.Parse(socket.RemoteEndPoint.ToString().Split(':')[1]);

            m_receiveAsyncEvent = new SocketAsyncEventArgs();
            m_receiveAsyncEvent.Completed += new EventHandler<SocketAsyncEventArgs>(m_receiveAsyncEvent_Completed);
        }

        void m_receiveAsyncEvent_Completed(object sender, SocketAsyncEventArgs e)
        {
            try
            {
                lock (this)
                {
                    if (e.BytesTransferred > 0)
                    {
                        if (CrossGlobal.SimpleCheck)
                        {
                            if (m_buffer[0] != '<') return;
                        }
                        else
                        {
                            string str = Encoding.UTF8.GetString(m_buffer);

                            if (str.IndexOf(CrossGlobal.CONDITION) == -1) return;
                        }

                        Socket.Send(CrossGlobal.POLICY);
                    }
                    else
                    {
                        Disconnect();
                    }
                }
            }
            catch (Exception ex)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine("数据包解析出错.");
                Console.WriteLine(ex);
                Console.ResetColor();
                Disconnect();
            }
            finally
            {
                AsyncReceiveImp();
            }
        }

        private void AsyncReceiveImp()
        {
            if (Socket != null && Socket.Connected)
            {
                m_receiveAsyncEvent.SetBuffer(m_buffer, 0, m_buffer.Length);

                if (Socket.ReceiveAsync(m_receiveAsyncEvent) == false)
                {
                    m_receiveAsyncEvent_Completed(Socket, m_receiveAsyncEvent);
                }
            }
        }

        public void AsyncReceive()
        {
            AsyncReceiveImp();
        }

        public virtual void Disconnect()
        {
            if (Socket != null)
            {
                try { Socket.Shutdown(SocketShutdown.Both); }
                catch { }

                try { Socket.Close(); }
                catch { }

                try
                {
                    if (DisconnectSocket != null)
                    {
                        DisconnectSocket(Socket);
                    }
                }
                catch
                { }

                Socket = null;
            }
        }
    }
}
