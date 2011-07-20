using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JsionFramework.Jsion;
using log4net;
using System.Reflection;
using System.IO;
using JsionFramework.Jsion.Attributes;

namespace GameServer
{
    public class GameServerConfig : AppConfigAbstract
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        #region 配置项

        [AppConfig("ServerID", "服务器编号", 0)]
        public int ServerID;

        [AppConfig("ServerName", "服务器名称", "未配置")]
        public string ServerName;

        [AppConfig("Port", "监听端口", 7711)]
        public int Port;

        [AppConfig("ServerConnectTryTimes", "服务器连接的重试次数,0表示直到连接上为止.", 0)]
        public int ServerConnectTryTimes;

        [AppConfig("CenterServerIP", "中心服务器IP地址", "127.0.0.1")]
        public string CenterServerIP;

        [AppConfig("CenterServerPort", "中心服务器端口", 7710)]
        public int CenterServerPort;

        [AppConfig("BattleServerList", "战斗服务器列表,格式: 'IP地址:端口号',多个以','隔开.", "127.0.0.1:7720")]
        public string BattleServerList;

        [AppConfig("ClientsCountMax", "最大连接数", 5000)]
        public int ClientsCountMax;

        #endregion










        public void Refresh()
        {
            Load(typeof(GameServerConfig));
        }

        protected override void Load(Type type)
        {
            base.Load(type);

            if (Assembly.GetEntryAssembly() == null)
            {
                RootDirectory = new FileInfo(Assembly.GetAssembly(typeof(GSServer)).Location).DirectoryName;
            }
        }

        public string RootDirectory;

    }
}
