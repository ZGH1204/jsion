using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JUtils.Messages
{
    public class MsgMonitor
    {
        private static readonly Dictionary<uint, List<IMsgReceiver>> msgReceiverList = new Dictionary<uint, List<IMsgReceiver>>();
        private static readonly Dictionary<string, IMsgReceiver> receiverList = new Dictionary<string, IMsgReceiver>();

        /// <summary>
        /// 注册指定消息的接收者
        /// </summary>
        /// <param name="msg"></param>
        /// <param name="receiver"></param>
        public static void RegisteMsgReceiver(uint msg, IMsgReceiver receiver)
        {
            if (!msgReceiverList.ContainsKey(msg))
            {
                msgReceiverList[msg] = new List<IMsgReceiver>();
            }

            if (msgReceiverList[msg].Contains(receiver))
            {
                //throw new Exception(receiver.ID + "已订阅 " + msg + " 消息，请不要重复订阅。");
                return;
            }

            msgReceiverList[msg].Add(receiver);
        }

        /// <summary>
        /// 移除指定消息的接收者
        /// </summary>
        /// <param name="msg"></param>
        /// <param name="receiver"></param>
        public static void RemoveMsgReceiver(uint msg, IMsgReceiver receiver)
        {
            if (!msgReceiverList.ContainsKey(msg))
            {
                return;
            }

            if (!msgReceiverList[msg].Contains(receiver))
            {
                return;
            }

            msgReceiverList[msg].Remove(receiver);
        }

        /// <summary>
        /// 注册消息接收者到列表
        /// </summary>
        /// <param name="receiver">接收者</param>
        public static void RegisteReceiver(IMsgReceiver receiver)
        {
            if (receiver == null)
            {
                throw new ArgumentNullException("receiver");
            }

            if (receiverList.ContainsKey(receiver.ID))
            {
                throw new Exception(receiver.ID + "接收者已存在，请更换ID。");
            }

            receiverList[receiver.ID] = receiver;
        }

        /// <summary>
        /// 从列表移除消息接收者
        /// </summary>
        /// <param name="id">接收者ID</param>
        public static void RemoveReceiver(string id)
        {
            if (id.IsNullOrEmpty()) return;

            if (!receiverList.ContainsKey(id)) return;

            receiverList.Remove(id);
        }

        /// <summary>
        /// 通过id获取消息接收者
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public static IMsgReceiver GetReceiver(string id)
        {
            if (id.IsNullOrEmpty()) return null;

            if (!receiverList.ContainsKey(id)) return null;

            return receiverList[id];
        }

        /// <summary>
        /// 创建消息
        /// </summary>
        /// <param name="msg">消息标识</param>
        /// <param name="sender">发送者</param>
        /// <param name="receivers">接收者列表</param>
        /// <param name="wParam">消息附加参数</param>
        /// <param name="lParam">消息附加参数</param>
        /// <returns></returns>
        public static Message CreateMsg(uint msg, string sender, string[] receivers = null, object wParam = null, object lParam = null)
        {
            Message m = new Message
            {
                Sender = sender,
                Receivers = receivers,
                Msg = msg,
                WParam = wParam,
                LParam = lParam,
                tick = Environment.TickCount
            };

            return m;
        }

        /// <summary>
        /// 同步发送消息
        /// </summary>
        /// <param name="msg"></param>
        /// <returns>所有接收者对应的返回值列表</returns>
        public static Dictionary<string, object> SendMsg(Message msg)
        {
            Dictionary<string, object> rlt = new Dictionary<string, object>();

            if (msgReceiverList.ContainsKey(msg.Msg))
            {
                foreach (IMsgReceiver receiver in msgReceiverList[msg.Msg])
                {
                    object obj = receiver.ReceiveSync(msg);
                    if (obj != null) rlt.Add(receiver.ID, obj);
                }
            }

            if (msg.Receivers != null && msg.Receivers.Length > 0)
            {
                foreach (string id in msg.Receivers)
                {
                    if (receiverList.ContainsKey(id))
                    {
                        object obj = receiverList[id].ReceiveSync(msg);
                        if (obj != null) rlt.Add(id, obj);
                    }
                }
            }

            return rlt;
        }

        /// <summary>
        /// 异步发送消息
        /// </summary>
        /// <param name="msg"></param>
        public static void PostMsg(Message msg)
        {
            if (msgReceiverList.ContainsKey(msg.Msg))
            {
                foreach (IMsgReceiver receiver in msgReceiverList[msg.Msg])
                {
                    receiver.ReceiveAsync(msg);
                }
            }

            if (msg.Receivers != null && msg.Receivers.Length > 0)
            {
                foreach (string id in msg.Receivers)
                {
                    if (receiverList.ContainsKey(id))
                    {
                        receiverList[id].ReceiveAsync(msg);
                    }
                }
            }
        }

        /// <summary>
        /// 创建并同步发送消息
        /// </summary>
        /// <param name="msg"></param>
        /// <param name="sender"></param>
        /// <param name="receivers"></param>
        /// <param name="wParam"></param>
        /// <param name="lParam"></param>
        public static Dictionary<string, object> CreateAndSendMsg(uint msg, string sender, string[] receivers = null, object wParam = null, object lParam = null)
        {
            Message m = CreateMsg(msg, sender, receivers, wParam, lParam);

            return SendMsg(m);
        }

        /// <summary>
        /// 创建并异步发送消息
        /// </summary>
        /// <param name="msg"></param>
        /// <param name="sender"></param>
        /// <param name="receivers"></param>
        /// <param name="wParam"></param>
        /// <param name="lParam"></param>
        public static void CreateAndPostMsg(uint msg, string sender, string[] receivers = null, object wParam = null, object lParam = null)
        {
            Message m = CreateMsg(msg, sender, receivers, wParam, lParam);

            PostMsg(m);
        }
    }
}
