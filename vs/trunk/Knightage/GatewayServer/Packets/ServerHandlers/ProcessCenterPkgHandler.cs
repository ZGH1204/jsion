using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase.Net;
using GameBase;

namespace GatewayServer.Packets.ServerHandlers
{
    [PacketHandler((int)BasePacketCode.Center_Code, "处理其他服务器从网关转发给中心服务器的数据包")]
    public class ProcessCenterPkgHandler : IServerPacketHandler
    {
        public int HandlePacket(ServerConnector connector, GamePacket packet)
        {
            GatewayGlobal.CenterServer.SendTCP(packet);

            return 0;
        }
    }
}
