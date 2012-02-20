using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Command;
using GameBase;
using System.Reflection;
using log4net;

namespace CenterServer.Commands.Startups
{
    [Cmd("InitTemplate", "初始化模板信息", "")]
    public class InitTemplateCmd : ICommand
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public bool Execute(string[] paramsList)
        {
            try
            {
                GameGlobal.GatewayMgr.Load(CenterServerConfig.Configuration.TemplateFile, "/root/ArrayOfGatewayInfo");
                GameGlobal.GameLogicMgr.Load(CenterServerConfig.Configuration.TemplateFile, "/root/ArrayOfGameLogicInfo");
                GameGlobal.BattleMgr.Load(CenterServerConfig.Configuration.TemplateFile, "/root/ArrayOfBattleInfo");

                return true;
            }
            catch (Exception ex)
            {
                log.Error("初始化模板信息失败", ex);
                return false;
            }
        }
    }
}
