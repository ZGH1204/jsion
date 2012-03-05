using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Command;
using GameBase.Packets;
using System.Reflection;
using log4net;

namespace GameServer.Commands.Startups
{
    [Cmd("SearchHandlers", "搜索处理类", "")]
    public class SearchHandlersCmd : ICommand
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public bool Execute(string[] paramsList)
        {
            try
            {
                PacketHandlers.SearchPacketHandler(Assembly.GetAssembly(typeof(AssemblyHelper)));

                return true;
            }
            catch (Exception ex)
            {
                log.Error("搜索处理类失败!", ex);
            }

            return false;
        }
    }
}
