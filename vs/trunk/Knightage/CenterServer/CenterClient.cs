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

        protected override void OnReceivePacket(GamePacket packet)
        {
            m_handlers.HandlePacket2(packet);
        }
    }
}
