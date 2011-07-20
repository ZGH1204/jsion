using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using log4net;
using JsionFramework.Jsion.Utils;
using ServerCommon.Jsion.Server;
using ServerCommon.Jsion.Packets;
using ServerCommon.Jsion.Attributes;
using GameServer.Interfaces;

namespace GameServer.Packages
{
    public class CenterPackageHandlers
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private ServerConnector m_connector;

        public CenterPackageHandlers(ServerConnector connector)
        {
            m_connector = connector;
        }

        public void HandlerPackage(JSNPackageIn pkg)
        {
            if (pkg == null)
            {
                log.Error("Package can not null!");
                return;
            }

            int code = pkg.Code;
            ICenterPackageHandler handler = null;

            if (m_packagesHandlers.ContainsKey(code))
            {
                handler = m_packagesHandlers[code];
            }
            else
            {
                log.ErrorFormat("Receive package's code is not exists! Code: {0}", code);
                log.Error(Marshal.ToHexDump(string.Format("Code: {0}", code), pkg.Buffer));
            }

            if (handler == null) return;

            long timeUsed = Environment.TickCount;

            try
            {
                handler.HandlePacket(m_connector, pkg);
            }
            catch (Exception ex)
            {
                string ep = m_connector.Socket.RemoteEndPoint;
                log.ErrorFormat("Error while processing package (handler={0}   RemoteEndPoint={1})", handler.GetType().FullName, ep);
                log.Error("Handle package error!", ex);
            }

            timeUsed = Environment.TickCount - timeUsed;

            log.InfoFormat("Package process time: {0}ms", timeUsed);

            if (timeUsed > 1000)
            {
                string source = m_connector.Socket.RemoteEndPoint;
                log.WarnFormat("({0}) Handle package thread {1} {2} took {3}ms!", source, System.Threading.Thread.CurrentThread.ManagedThreadId, handler, timeUsed);
            }
        }


        #region HandlerList

        private static readonly Dictionary<int, ICenterPackageHandler> m_packagesHandlers = new Dictionary<int, ICenterPackageHandler>(256);

        public static int SearchPackageHandler(Assembly ass)
        {
            int count = 0;
            m_packagesHandlers.Clear();

            Type[] tList = ass.GetTypes();

            string interfaceStr = typeof(ICenterPackageHandler).ToString();

            foreach (Type type in tList)
            {
                if (type.IsClass != true) continue;

                if (type.GetInterface(interfaceStr) == null) continue;

                CenterPackageHandlerAttribute[] atts = (CenterPackageHandlerAttribute[])type.GetCustomAttributes(typeof(CenterPackageHandlerAttribute), true);

                if (atts.Length > 0)
                {
                    count++;
                    RegisterPacketHandler(atts[0].Code, (ICenterPackageHandler)Activator.CreateInstance(type));
                    //m_packagesHandlers[atts[0].Code] = (IPackageHandler)Activator.CreateInstance(type);
                }
            }

            return count;
        }

        private static void RegisterPacketHandler(int code, ICenterPackageHandler iPackageHandler)
        {
            CenterPackageHandlers.m_packagesHandlers[code] = iPackageHandler;
        }

        #endregion
    }
}
