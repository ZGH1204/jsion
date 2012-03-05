using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase.Net;
using System.Reflection;
using log4net;
using GameBase;

namespace CenterServer.Packets
{
    public class CenterPacketHandlers : PacketHandlers
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected CenterClient m_centerClient;

        private int m_validateCode;

        public CenterPacketHandlers(CenterClient client)
            : base(client)
        {
            m_centerClient = client;
            m_validateCode = (int)BasePacketCode.ValidateServer;
        }

        public override void HandlePacket(GamePacket packet)
        {
            if (m_centerClient.Validated)
            {
                base.HandlePacket(packet);
            }
            else
            {
                if (packet == null)
                {
                    log.Error("Packet is null!");
                    return;
                }

                if (packet.Code == m_validateCode)
                {
                    HandlePacket(packet.Code, packet);
                }
                else
                {
                    m_centerClient.Disconnect();
                }
            }
        }
    }
}
