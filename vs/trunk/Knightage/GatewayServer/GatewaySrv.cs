using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using System.Net.Sockets;
using System.Threading;
using GatewayServer.Packets.OutPackets.Servers;
using GatewayServer.Packets.OutPackets;

namespace GatewayServer
{
    public class GatewaySrv : ServerBase
    {
        public bool Fulled { get; protected set; }

        private System.Timers.Timer m_timer;

        public GatewaySrv()
            : base()
        { }

        protected override ClientBase CreateClient(Socket socket)
        {
            GatewayClient client = new GatewayClient();

            client.Accept(socket);

            Interlocked.Increment(ref GatewayGlobal.ClientCount);

            client.ClientID = GatewayGlobal.ClientCount;

            return client;
        }

        protected override void SaveClient(ClientBase client)
        {
            base.SaveClient(client);

            GatewayClient c = (GatewayClient)client;

            GatewayGlobal.PlayerClientMgr.Add(c.ClientID, c);

            if (Fulled)
            {
                ConnectOtherGatewayPacket pkg = new ConnectOtherGatewayPacket();
                pkg.GatewayID = GatewayGlobal.GatewayID;
                pkg.ClientID = ((GatewayClient)client).ClientID;
                GatewayGlobal.CenterServer.SendTCP(pkg);

                return;
            }
            else if (GatewayGlobal.PlayerClientMgr.Count > GatewayServerConfig.Configuration.MaxClients)
            {
                UpdateServerFullPacket pkg = new UpdateServerFullPacket();

                pkg.GatewayID = GatewayGlobal.GatewayID;
                pkg.ClientID = ((GatewayClient)client).ClientID;

                GatewayGlobal.CenterServer.SendTCP(pkg);

                Fulled = true;

                m_timer = new System.Timers.Timer(GatewayServerConfig.Configuration.FullInterval * 1000);
                m_timer.Elapsed += new System.Timers.ElapsedEventHandler(m_timer_Elapsed);
                m_timer.Start();
            }
            else
            {
                NoticeLoginPacket pkg = new NoticeLoginPacket();

                client.SendTcp(pkg);
            }
        }

        void m_timer_Elapsed(object sender, System.Timers.ElapsedEventArgs e)
        {
            Fulled = false;

            UpdateServerNormalPacket pkg = new UpdateServerNormalPacket();
            pkg.GatewayID = GatewayGlobal.GatewayID;
            GatewayGlobal.CenterServer.SendTCP(pkg);

            if (m_timer != null)
            {
                m_timer.Stop();
                m_timer.Elapsed -= m_timer_Elapsed;
                m_timer = null;
            }
        }

        private static readonly GatewaySrv m_server = new GatewaySrv();

        public static GatewaySrv Server { get { return m_server; } }
    }
}
