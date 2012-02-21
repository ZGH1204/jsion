using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;
using GameBase.Packets.OutPackets;
using GameBase.ServerConfigs;

namespace CenterServer.Packets.Handlers
{
    [PacketHandler((int)BasePacketCode.ValidateServer, "验证服务器类型和有效性")]
    public class ValidateServerTypeHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            CenterClient center = client as CenterClient;

            ServerType type = (ServerType)packet.ReadUnsignedByte();

            string ip = packet.ReadUTF();

            int port = packet.ReadInt();

            int id = 0;

            switch (type)
            {
                //case ServerType.UnKnowServer:
                //    break;
                //case ServerType.CenterServer:
                //    break;
                case ServerType.LogicServer:
                    id = GameGlobal.GameLogicMgr.GetID(info => info.IP == ip && info.Port == port);
                    if (id > 0)
                    {
                        CenterGlobal.GameLogicServerMgr.Add(id, center);
                        CenterGlobal.GatewayServerMgr.ForEach((c) => {
                            ConnectLogicServerPacket pkg = new ConnectLogicServerPacket();
                            pkg.ID = id;
                            pkg.IP = ip;
                            pkg.Port = port;
                            c.SendTcp(pkg);
                        });
                    }
                    break;
                case ServerType.BattleServer:
                    id = GameGlobal.BattleMgr.GetID(info => info.IP == ip && info.Port == port);
                    if (id > 0)
                    {
                        CenterGlobal.BattleServerMgr.Add(id, center);
                        CenterGlobal.GatewayServerMgr.ForEach((c) =>
                        {
                            ConnectBattleServerPacket pkg = new ConnectBattleServerPacket();
                            pkg.ID = id;
                            pkg.IP = ip;
                            pkg.Port = port;
                            c.SendTcp(pkg);
                        });
                    }
                    break;
                case ServerType.GatewayServer:
                    id = GameGlobal.GatewayMgr.GetID(info => info.IP == ip && info.Port == port);
                    if (id > 0)
                    {
                        CenterGlobal.GatewayServerMgr.Add(id, center);

                        int[] keys = CenterGlobal.GameLogicServerMgr.GetKeys();

                        foreach (int key in keys)
                        {
                            GameLogicInfo info = GameGlobal.GameLogicMgr.FindTemplate(key);
                            ConnectLogicServerPacket pkg = new ConnectLogicServerPacket();
                            pkg.ID = key;
                            pkg.IP = info.IP;
                            pkg.Port = info.Port;
                            center.SendTcp(pkg);
                        }

                        keys = CenterGlobal.BattleServerMgr.GetKeys();
                        foreach (int key in keys)
                        {
                            BattleInfo info = GameGlobal.BattleMgr.FindTemplate(key);
                            ConnectBattleServerPacket pkg = new ConnectBattleServerPacket();
                            pkg.ID = key;
                            pkg.IP = info.IP;
                            pkg.Port = info.Port;
                            center.SendTcp(pkg);
                        }
                    }
                    break;
                default:
                    center.Disconnect();
                    return 0;
            }

            if (id > 0)
            {
                center.ID = id;
                center.Type = type;
                center.Validated = true;
            }
            else
            {
                center.Disconnect();
            }

            return 0;
        }
    }
}
