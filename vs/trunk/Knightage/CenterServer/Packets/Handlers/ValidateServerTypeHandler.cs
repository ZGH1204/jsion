using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;
using GameBase.Packets.OutPackets;
using GameBase.ServerConfigs;
using log4net;
using System.Reflection;

namespace CenterServer.Packets.Handlers
{
    [PacketHandler((int)BasePacketCode.ValidateServer, "验证服务器类型和有效性")]
    public class ValidateServerTypeHandler : IPacketHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            HandlePacket(client as CenterClient, packet);

            return 0;
        }


        void HandlePacket(CenterClient client, GamePacket pkg)
        {
            //服务器类型
            ServerType type = (ServerType)pkg.ReadUnsignedByte();

            //服务器监听地址和端口
            string ip = pkg.ReadUTF();
            int port = pkg.ReadInt();

            int id = 0;

            switch (type)
            {
                case ServerType.LogicServer:
                    {
                        id = CenterGlobal.LogicMgr.GetID(info => info.IP == ip && info.Port == port);

                        if (id > 0)
                        {
                            CenterGlobal.LogicServerMgr.Add(id, client);
                            client.Disconnected += new DisconnectDelegate(logic_Client_Disconnected);

                            //通知所有网关服务器连接逻辑服务器
                            CenterGlobal.GatewayServerMgr.ForEach(gateway =>
                            {
                                ConnectLogicServerPacket p = new ConnectLogicServerPacket();

                                p.ID = id;
                                p.IP = ip;
                                p.Port = port;

                                gateway.SendTcp(p);
                            });
                        }
                        break;
                    }
                case ServerType.BattleServer:
                    {
                        id = CenterGlobal.BattleMgr.GetID(info => info.IP == ip && info.Port == port);

                        if (id > 0)
                        {
                            CenterGlobal.BattleServerMgr.Add(id, client);
                            client.Disconnected += new DisconnectDelegate(battle_Client_Disconnected);

                            //通知所有网关服务器连接战斗服务器
                            CenterGlobal.GatewayServerMgr.ForEach(gateway =>
                            {
                                ConnectBattleServerPacket p = new ConnectBattleServerPacket();

                                p.ID = id;
                                p.IP = ip;
                                p.Port = port;

                                gateway.SendTcp(p);
                            });
                        }
                        break;
                    }
                case ServerType.GatewayServer:
                    {
                        id = CenterGlobal.GatewayMgr.GetID(info => info.IP == ip && info.Port == port);

                        if (id > 0)
                        {
                            CenterGlobal.GatewayServerMgr.Add(id, client);
                            client.Disconnected += new DisconnectDelegate(gateway_Client_Disconnected);

                            //更新网关ID
                            UpdateServerIDPacket pkt = new UpdateServerIDPacket();
                            pkt.ID = (byte)id;
                            client.SendTcp(pkt);

                            //遍历所有逻辑服务器,通知网关连接.
                            CenterGlobal.LogicServerMgr.ForEachKey(lid =>
                            {
                                GameLogicInfo info = CenterGlobal.LogicMgr.FindTemplate(lid);

                                ConnectLogicServerPacket p = new ConnectLogicServerPacket();

                                p.ID = info.TemplateID;
                                p.IP = info.IP;
                                p.Port = info.Port;

                                client.SendTcp(p);
                            });

                            //遍历所有战斗服务器,通知网关连接.
                            CenterGlobal.BattleServerMgr.ForEachKey(tid =>
                            {
                                BattleInfo info = CenterGlobal.BattleMgr.FindTemplate(tid);

                                ConnectBattleServerPacket p = new ConnectBattleServerPacket();

                                p.ID = info.TemplateID;
                                p.IP = info.IP;
                                p.Port = info.Port;

                                client.SendTcp(p);
                            });
                        }
                        break;
                    }
            }

            //有效连接时设置服务器信息
            if (id > 0)
            {
                client.ServerID = id;
                client.Type = type;
                client.Validated = true;
            }
            else
            {
                log.ErrorFormat("服务器验证无效! IP:{0}  Port:{1}", ip, port);
                client.Disconnect();
            }
        }

        static void gateway_Client_Disconnected(ClientBase client)
        {
            CenterGlobal.GatewayServerMgr.Remove(((CenterClient)client).ServerID);

            client.Disconnected -= gateway_Client_Disconnected;
        }

        static void battle_Client_Disconnected(ClientBase client)
        {
            CenterGlobal.BattleServerMgr.Remove(((CenterClient)client).ServerID);

            client.Disconnected -= battle_Client_Disconnected;
        }

        static void logic_Client_Disconnected(ClientBase client)
        {
            CenterGlobal.LogicServerMgr.Remove(((CenterClient)client).ServerID);

            client.Disconnected -= logic_Client_Disconnected;
        }
    }
}
