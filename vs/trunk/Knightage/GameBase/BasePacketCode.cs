using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GameBase
{
    /// <summary>
    /// 0-100为预留协议号
    /// </summary>
    public enum BasePacketCode
    {
        /// <summary>
        /// 转发给中心服务器
        /// </summary>
        Center_Code = 1,

        /// <summary>
        /// 转发给战斗服务器
        /// </summary>
        Battle_Code = 2,

        /// <summary>
        /// 转发给逻辑服务器
        /// </summary>
        Logic_Code = 3,



        /// <summary>
        /// 验证服务器IP、端口、类型
        /// </summary>
        ValidateServer = 101,

        /// <summary>
        /// 连接逻辑服务器
        /// </summary>
        ConnectLogicServer = 102,

        /// <summary>
        /// 连接战斗服务器
        /// </summary>
        ConnectBattleServer = 103
    }
}
