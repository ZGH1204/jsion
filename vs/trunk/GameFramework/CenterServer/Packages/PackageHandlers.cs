using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using log4net;
using ServerCommon.Jsion.Packets;
using JsionFramework.Jsion.Utils;
using ServerCommon.Jsion.Attributes;
using CenterServer.Interfaces;

namespace CenterServer.Packages
{
    public class PackageHandlers
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected ServerClient m_client;

        public PackageHandlers(ServerClient client)
        {
            m_client = client;
        }

        public void HandlerPackage(JSNPackageIn pkg)
        {
            if (pkg == null)
            {
                log.Error("Package can not null!");
                return;
            }

            int code = pkg.Code;
            IPackageHandler handler = null;

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
                handler.HandlePacket(m_client, pkg);
            }
            catch (Exception ex)
            {
                string ep = m_client.Socket.RemoteEndPoint;
                log.ErrorFormat("Error while processing package (handler={0}   RemoteEndPoint={1})", handler.GetType().FullName, ep);
                log.Error("Handle package error!", ex);
            }

            timeUsed = Environment.TickCount - timeUsed;

            log.InfoFormat("Package process time: {0}ms", timeUsed);

            if (timeUsed > 1000)
            {
                string source = m_client.Socket.RemoteEndPoint;
                log.WarnFormat("({0}) Handle package thread {1} {2} took {3}ms!", source, System.Threading.Thread.CurrentThread.ManagedThreadId, handler, timeUsed);
            }
        }


        #region HandlerList

        private static readonly Dictionary<int, IPackageHandler> m_packagesHandlers = new Dictionary<int, IPackageHandler>(256);

        public static int SearchPackageHandler(Assembly ass)
        {
            int count = 0;
            m_packagesHandlers.Clear();

            Type[] tList = ass.GetTypes();

            string interfaceStr = typeof(IPackageHandler).ToString();

            foreach (Type type in tList)
            {
                if (type.IsClass != true) continue;

                if (type.GetInterface(interfaceStr) == null) continue;

                PackageHandlerAttribute[] atts = (PackageHandlerAttribute[])type.GetCustomAttributes(typeof(PackageHandlerAttribute), true);

                if (atts.Length > 0)
                {
                    count++;
                    RegisterPacketHandler(atts[0].Code, (IPackageHandler)Activator.CreateInstance(type));
                    //m_packagesHandlers[atts[0].Code] = (IPackageHandler)Activator.CreateInstance(type);
                }
            }

            return count;
        }

        private static void RegisterPacketHandler(int code, IPackageHandler iPackageHandler)
        {
            PackageHandlers.m_packagesHandlers[code] = iPackageHandler;
        }

        #endregion
    }
}
