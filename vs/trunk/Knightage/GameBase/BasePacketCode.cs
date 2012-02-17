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
    }
}
