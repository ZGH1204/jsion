using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GameBase
{
    public enum MsgFlag : short
    {
        /// <summary>
        /// 没有可用中心服务器
        /// </summary>
        NoneCenter = 1,

        /// <summary>
        /// 没有可用逻辑服务器
        /// </summary>
        NoneLogic = 2,

        /// <summary>
        /// 没有可用战斗服务器
        /// </summary>
        NoneBattle = 3,

        /// <summary>
        /// 没有可用网关服务器
        /// </summary>
        NoneGateway = 4
    }
}
