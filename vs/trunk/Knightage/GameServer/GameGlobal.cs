using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using GameBase.Managers;
using GameServer.Packet.OutServerPackets;
using System.Timers;

namespace GameServer
{
    public class GameGlobal
    {
        public static readonly CenterServerConnector CenterServer = new CenterServerConnector(ServerType.LogicServer, GameServerConfig.Configuration.Port);



        public static readonly ObjectMgr<int, GamePlayer> PlayerMgr = new ObjectMgr<int, GamePlayer>();



        private static bool m_fulled = false;
        private static object m_syncRoot = new object();
        private static Timer m_timer = new Timer();

        public static void CheckMaxClientCount()
        {
            lock (m_syncRoot)
            {
                if (m_fulled) return;
            }

            if (GameGlobal.PlayerMgr.Count >= GameServerConfig.Configuration.MaxClients)
            {
                lock (m_syncRoot)
                {
                    if (m_fulled == false)
                    {
                        ClientMgr.Instance.ForEach(client =>
                        {
                            UpdateServerFullPacket pkg = new UpdateServerFullPacket();

                            client.SendTcp(pkg);
                        });
                    }

                    m_fulled = true;

                    m_timer.Interval = 300 * 1000;
                    m_timer.Elapsed += new ElapsedEventHandler(m_timer_Elapsed);
                    m_timer.AutoReset = true;
                    m_timer.Start();
                }
            }


        }

        static void m_timer_Elapsed(object sender, ElapsedEventArgs e)
        {
            lock (m_syncRoot)
            {
                m_fulled = false;

                ClientMgr.Instance.ForEach(client =>
                {
                    UpdateServerNormalPacket pkg = new UpdateServerNormalPacket();

                    client.SendTcp(pkg);
                });

                m_timer.Elapsed -= m_timer_Elapsed;

                m_timer.Stop();
            }
        }
    }
}
