using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using log4net;
using System.Reflection;
using ServerCommon.Jsion.Server;
using JsionFramework.Jsion.Utils;
using ServerCommon.Jsion.Packets;
using GameServer.Interfaces;
using ServerCommon.Jsion.Attributes;

namespace GameServer.Packages
{
    public class FightPackageHandlers
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private ServerConnector m_connector;

        public FightPackageHandlers(ServerConnector connector)
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
            IFightPackageHandler handler = null;

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

        private static readonly Dictionary<int, IFightPackageHandler> m_packagesHandlers = new Dictionary<int, IFightPackageHandler>(256);

        public static int SearchPackageHandler(Assembly ass)
        {
            int count = 0;
            m_packagesHandlers.Clear();

            Type[] tList = ass.GetTypes();

            string interfaceStr = typeof(IFightPackageHandler).ToString();

            foreach (Type type in tList)
            {
                if (type.IsClass != true) continue;

                if (type.GetInterface(interfaceStr) == null) continue;

                FightPackageHandlerAttribute[] atts = (FightPackageHandlerAttribute[])type.GetCustomAttributes(typeof(FightPackageHandlerAttribute), true);

                if (atts.Length > 0)
                {
                    count++;
                    RegisterPacketHandler(atts[0].Code, (IFightPackageHandler)Activator.CreateInstance(type));
                }
            }

            return count;
        }

        private static void RegisterPacketHandler(int code, IFightPackageHandler iPackageHandler)
        {
            FightPackageHandlers.m_packagesHandlers[code] = iPackageHandler;
        }

        #endregion
    }
}
