using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ServerCommon.Jsion.Managers;
using ServerCommon.Jsion.Server;

namespace GameServer.Managers
{
    public class GameServerMgr : ServerMgr
    {
        public static CenterServer CenterServer = null;

        public static void ConnectCenterServer()
        {
            if (CenterServer == null)
            {
                CenterServer = new CenterServer(string.Format("中心服务器({0}:{1})", GSConfigMgr.Configuration.CenterServerIP, GSConfigMgr.Configuration.CenterServerPort));
            }

            CenterServer.Connect(GSConfigMgr.Configuration.CenterServerIP, GSConfigMgr.Configuration.CenterServerPort);
        }
    }
}
