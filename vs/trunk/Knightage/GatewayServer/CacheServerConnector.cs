using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using log4net;
using System.Reflection;

namespace GatewayServer
{
    public class CacheServerConnector : ServerConnector
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public CacheServerConnector(string ip, int port)
            : base(ip, port)
        { }

        public override string ServerName
        {
            get
            {
                return "缓存服务器";
            }
        }

        protected override void OnInitialize()
        {
        }
        protected override void OnConnected(bool successed)
        {
            if (successed)
            {
                log.InfoFormat("{2}连接成功!IP:{0}, Port:{1}", Socket.IP, Socket.Port, ServerName);
            }
            else
            {
                log.ErrorFormat("{2}连接失败!IP:{0}, Port:{1}", Socket.IP, Socket.Port, ServerName);
            }
        }
        protected override void OnDisconnect()
        {
            GatewayGlobal.CacheServer = null;
        }
    }
}
