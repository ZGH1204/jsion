using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameServer.Interfaces;
using ServerCommon.Jsion.Attributes;
using ServerCommon.Jsion.Packets;

namespace GameServer.Packages.Handlers.Client
{
    [PackageHandler(999, "测试数据包")]
    public class TestPackageHandler : IPackageHandler
    {
        public int HandlePacket(GameClient client, JSNPackageIn pkg)
        {
            Console.WriteLine("{3}, {0}, {1}, {2}", pkg.readInt(), pkg.readUTF(), pkg.readInt(), pkg.readShort());

            for (int i = 0; i < 80; i++)
            {
                JSNPackageIn p = new JSNPackageIn(2048);

                p.Code = 990;

                p.writeInt(i);

                p.writeUTF("服务端测试包");

                //p.writeShort((short)i);

                client.SendOut.SendTCP(p);
            }
            return 0;
        }
    }
}
