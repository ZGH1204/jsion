using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using System.Net.Sockets;
using GameBase.Packets;
using GameBase.Net;

namespace CenterServer
{
    public class CenterClient : ClientBase
    {
        public CenterClient()
            : base()
        { }

        public byte[] sBuffer
        {
            get
            {
                if (m_socket != null)
                {
                    return m_socket.SendBuffer;
                }

                return null;
            }
        }

        public byte[] rBuffer
        {
            get
            {
                if (m_socket != null)
                {
                    return m_socket.ReceiveBuffer;
                }

                return null;
            }
        }

        public override void Accept(Socket socket)
        {
            Accept(socket, BufferMgr.AcquireBuffer(), BufferMgr.AcquireBuffer());
        }

        protected override void OnDisconnected()
        {
            BufferMgr.ReleaseBuffer(sBuffer);

            BufferMgr.ReleaseBuffer(rBuffer);

            base.OnDisconnected();
        }


        protected PacketHandlers handlers;

        protected override void Initialize()
        {
            handlers = new PacketHandlers(this);
        }

        protected override void OnReceivePacket(GamePacket packet)
        {
            handlers.HandlePacket2(packet);
        }
    }
}
