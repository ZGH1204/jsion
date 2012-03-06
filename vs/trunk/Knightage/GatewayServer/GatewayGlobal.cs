using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Managers;
using GameBase;
using GameBase.Net;
using GatewayServer.Packets.OutClientPackets;
using GatewayServer.Packets.OutServerPackets;
using System.Timers;

namespace GatewayServer
{
    public class GatewayGlobal
    {
        public static uint GatewayID = 0;

        public static uint ClientCount = 0;

        public static readonly CenterServerConnector CenterServer = new CenterServerConnector(ServerType.GatewayServer, GatewayServerConfig.Configuration.Port);

        public static readonly ObjectMgr<uint, BattleServerConnector> ConnectingMgr = new ObjectMgr<uint, BattleServerConnector>();

        public static readonly ObjectMgr<uint, BattleServerConnector> BattleServerMgr = new ObjectMgr<uint, BattleServerConnector>();

        public static readonly ObjectMgr<uint, LogicServerConnector> LogicConnectingMgr = new ObjectMgr<uint, LogicServerConnector>();

        public static readonly ObjectMgr<uint, LogicServerConnector> LogicServerMgr = new ObjectMgr<uint, LogicServerConnector>();



        public static readonly ObjectMgr<uint, GatewayClient> Clients = new ObjectMgr<uint, GatewayClient>();
        public static readonly ObjectMgr<uint, GatewayPlayer> Players = new ObjectMgr<uint, GatewayPlayer>();


        //当前网关相关状态

        private static bool Fulled = false;

        private static readonly object m_syncRoot = new object();

        private static Timer m_timer = new Timer();

        public static void CheckMaxClientCount(GatewayClient client)
        {
            lock (m_syncRoot)
            {
                if (Fulled)
                {
                    //TODO: 服务器已满 请求中心服务器更换网关

                    ChangeGatewayPacket pkg = new ChangeGatewayPacket();

                    pkg.ClientID = client.ClientID;

                    GatewayGlobal.CenterServer.SendTCP(pkg);

                    return;
                }
            }

            if (ClientMgr.Instance.ClientCount >= GatewayServerConfig.Configuration.MaxClients)
            {
                lock (m_syncRoot)
                {
                    Fulled = true;
                }

                //TODO: 通知中心服务器此网关已满 并N分钟后重置为未满

                UpdateServerFullPacket pkg = new UpdateServerFullPacket();

                pkg.ClientID = client.ClientID;

                GatewayGlobal.CenterServer.SendTCP(pkg);

                m_timer.Interval = 300 * 1000;
                m_timer.Elapsed += new ElapsedEventHandler(m_timer_Elapsed);
                m_timer.AutoReset = true;
                m_timer.Start();
            }
            else
            {
                //TODO: 通知客户端登陆

                NoticeLoginPacket pkg = new NoticeLoginPacket();

                client.SendTcp(pkg);
            }
        }

        static void m_timer_Elapsed(object sender, ElapsedEventArgs e)
        {
            lock (m_syncRoot)
            {
                Fulled = false;
            }

            UpdateServerNormalPacket pkg = new UpdateServerNormalPacket();

            GatewayGlobal.CenterServer.SendTCP(pkg);
        }



        //逻辑服务器相关

        private static uint m_freeID;

        public static LogicServerConnector GetFreeLogicServer(GatewayClient client)
        {
            LogicServerConnector connector = LogicServerMgr[m_freeID];

            if (connector != null)
            {
                return connector;
            }

            connector = LogicServerMgr.SelectSingle(conn => conn.Fulled == false);

            if (connector != null)
            {
                m_freeID = connector.ID;

                return connector;
            }
            else
            {
                //TODO: 通知客户端逻辑服务器已满 稍候登陆
            }

            return null;
        }
    }
}
