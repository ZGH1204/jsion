using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BattleHeartGame
{
    public class MsgGloba
    {
        public const uint Dispose = uint.MaxValue;

        #region NetWork

        /// <summary>
        /// 设置Socket，Type对象。
        /// 消息标识：1
        /// wParam: 继承JSocket并覆盖配置属性的类的Type类型
        /// </summary>
        public const uint SetSocketType = 1;

        ////////////////////////////////    允许接收并处理的消息    ////////////////////////////////

        /// <summary>
        /// 帧听本地端口
        /// 消息标识：11
        /// </summary>
        public const uint Listen = 11;

        /// <summary>
        /// 关闭帧听或连接
        /// 消息标识：12
        /// </summary>
        public const uint Close = 12;

        /// <summary>
        /// 连接到指定主机
        /// 消息标识：13
        /// </summary>
        public const uint Connect = 13;


        ////////////////////////////////    对外发送消息列表    ////////////////////////////////

        /// <summary>
        /// 帧听或连接已关闭
        /// 消息标识：16
        /// </summary>
        public const uint Disconnected = 16;

        /// <summary>
        /// 接收到Socket连接
        /// 消息标识：17
        /// </summary>
        public const uint Accepted = 17;

        /// <summary>
        /// 收到数据包
        /// 消息标识：18
        /// </summary>
        public const uint Received = 18;

        /// <summary>
        /// 连接错误
        /// 消息标识：19
        /// </summary>
        public const uint Errored = 19;

        /// <summary>
        /// 连接成功
        /// 消息标识：20
        /// </summary>
        public const uint Connected = 20;

        #endregion
    }
}
