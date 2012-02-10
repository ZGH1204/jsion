using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using log4net;
using System.Reflection;
using Net;
using GameBase.Net;

namespace GameBase.Packets
{
    public class PacketHandlers
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected ClientBase m_client;

        public PacketHandlers(ClientBase client)
        {
            m_client = client;
        }

        public void HandlePacket(GamePacket packet)
        {
            if (packet == null)
            {
                log.Error("Packet is null!");
                return;
            }

            int code = packet.Code;

            IPacketHandler handler = null;

            if (m_packagesHandlers.ContainsKey(code))
            {
                handler = m_packagesHandlers[code];
            }
            else
            {
                log.ErrorFormat("Receive package's code is not exists! Code: {0}", code);
                log.Error(Marshal.ToHexDump(string.Format("Code: {0}", code), packet.Buffer));
                return;
            }

            long timeUsed = Environment.TickCount;

            try
            {
                handler.HandlePacket(m_client, packet);
            }
            catch (Exception ex)
            {
                log.ErrorFormat("Error while processing package (handler={0})", handler.GetType().FullName);
                log.Error("Handle package error!", ex);
            }

            timeUsed = Environment.TickCount - timeUsed;

            log.InfoFormat("Package process time: {0}ms", timeUsed);

            if (timeUsed > 1000)
            {
                log.WarnFormat("Handle package thread {0} {1} took {2}ms!", System.Threading.Thread.CurrentThread.ManagedThreadId, handler, timeUsed);
            }
        }


        #region 搜索初始化

        private static readonly Dictionary<int, IPacketHandler> m_packagesHandlers = new Dictionary<int, IPacketHandler>(256);

        public static int SearchPacketHandler(Assembly ass)
        {
            int count = 0;

            m_packagesHandlers.Clear();

            Type[] tList = ass.GetTypes();

            string interfaceStr = typeof(IPacketHandler).ToString();

            foreach (Type type in tList)
            {
                if (type.IsClass != true) continue;

                if (type.GetInterface(interfaceStr) == null) continue;

                PacketHandlerAttribute attribute = (PacketHandlerAttribute)type.GetCustomAttributes(typeof(PacketHandlerAttribute), true).FirstOrDefault();

                if (attribute != null)
                {
                    if (m_packagesHandlers.ContainsKey(attribute.Code))
                    {
                        log.ErrorFormat("Packet code {0} already exists.", attribute.Code);
                        continue;
                    }

                    count++;

                    RegisterPacketHandler(attribute.Code, (IPacketHandler)Activator.CreateInstance(type));
                }
            }

            log.InfoFormat("Search {0} packet handlers successed!", count);

            return count;
        }

        private static void RegisterPacketHandler(int code, IPacketHandler iPackageHandler)
        {
            m_packagesHandlers[code] = iPackageHandler;
        }

        #endregion
    }
}
