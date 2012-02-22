using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GameBase
{
    /// <summary>
    /// 0-100为Code2预留协议号
    /// 101-200为服务器间的预留协议号
    /// 200以上为游戏逻辑协议号
    /// </summary>
    public enum BasePacketCode
    {
        /// <summary>
        /// 转发给中心服务器处理
        /// </summary>
        Center_Code = 1,

        /// <summary>
        /// 转发给战斗服务器处理
        /// </summary>
        Battle_Code = 2,

        /// <summary>
        /// 转发给逻辑服务器处理
        /// </summary>
        Logic_Code = 3,

        /// <summary>
        /// 转发给网关服务器处理
        /// </summary>
        Gateway_Code = 4,



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
        ConnectBattleServer = 103,


        /// <summary>
        /// 玩家登陆
        /// </summary>
        Login = 201,
    }
}
