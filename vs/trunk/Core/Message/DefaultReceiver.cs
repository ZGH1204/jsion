using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using System.Threading;
using log4net;
using System.Reflection;

namespace Message
{
    public class DefaultReceiver : IMsgReceiver
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public Dictionary<uint, MsgAction<Message>> MsgHandlers { get; protected set; }

        public Dictionary<uint, JMethodInfo> MsgMethodInfos { get; protected set; }

        public Queue MsgList { get; protected set; }

        public bool Handling { get; protected set; }

        public DefaultReceiver(string id)
        {
            ID = id;
            Handling = false;
            MsgList = new Queue();
            MsgMethodInfos = new Dictionary<uint, JMethodInfo>();
            MsgHandlers = new Dictionary<uint, MsgAction<Message>>();

            MsgMonitor.RegisteReceiver(this);

            RegisteMsgHandler(MsgType.Dispose, Dispose);

            ParseMsgHandler(this);
        }

        #region 发送消息

        public Dictionary<string, object> CreateAndSendMsg(uint msg, string[] receivers = null, object wParam = null, object lParam = null)
        {
            return MsgMonitor.CreateAndSendMsg(msg, ID, null, wParam, lParam);
        }

        public void CreateAndPostMsg(uint msg, string[] receivers = null, object wParam = null, object lParam = null)
        {
            MsgMonitor.CreateAndPostMsg(msg, ID, receivers, wParam, lParam);
        }

        #endregion

        #region 注册IMsgReceiver和消息对应处理函数

        public void ParseMsgHandler(object obj)
        {
            Type type = obj.GetType();

            MethodInfo[] list = type.GetMethods();

            foreach (MethodInfo method in list)
            {
                MsgHandlerAttribute[] attributes = (MsgHandlerAttribute[])method.GetCustomAttributes(typeof(MsgHandlerAttribute), true);

                JMethodInfo m = new JMethodInfo(obj, method);

                if (attributes.Length > 0)
                {
                    if (attributes[0].SubscibeHandler)
                    {
                        RegisteReceiveMsg(attributes[0].Msg, m);
                    }
                    else
                    {
                        RegisteMsgHandler(attributes[0].Msg, m);
                    }
                }
            }
        }

        public void RegisteReceiveMsg(uint msg, MsgAction<Message> action)
        {
            MsgMonitor.RegisteMsgReceiver(msg, this);
            RegisteMsgHandler(msg, action);
        }

        public void RegisteReceiveMsg(uint msg, JMethodInfo method)
        {
            MsgMonitor.RegisteMsgReceiver(msg, this);
            RegisteMsgHandler(msg, method);
        }

        public void RemoveReceiveMsg(uint msg)
        {
            MsgMonitor.RemoveMsgReceiver(msg, this);
            RemoveMsgHandler(msg);
        }

        public void RegisteMsgHandler(uint msg, MsgAction<Message> action)
        {
            if (MsgHandlers.ContainsKey(msg))
            {
                //log.ErrorFormat("{0} 消息已存在处理函数,无法注册.", msg);
                //return;
                throw new Exception(msg + " 消息已存在处理函数,无法注册.");
            }

            MsgHandlers[msg] = action;
        }

        public void RegisteMsgHandler(uint msg, JMethodInfo method)
        {
            if (MsgMethodInfos.ContainsKey(msg))
            {
                //log.ErrorFormat("{0} 消息已存在处理方法信息,无法注册.", msg);
                //return;
                throw new Exception(msg + " 消息已存在处理方法信息,无法注册.");
            }

            MsgMethodInfos[msg] = method;
        }

        public void RemoveMsgHandler(uint msg)
        {
            if (MsgHandlers.ContainsKey(msg))
            {
                MsgHandlers.Remove(msg);
            }

            if (MsgMethodInfos.ContainsKey(msg))
            {
                MsgMethodInfos.Remove(msg);
            }
        }

        public void ClearHandlers()
        {
            foreach (uint msg in MsgHandlers.Keys)
            {
                RemoveReceiveMsg(msg);
            }

            foreach (uint msg in MsgMethodInfos.Keys)
            {
                RemoveReceiveMsg(msg);
            }

            MsgHandlers.Clear();
            MsgMethodInfos.Clear();
        }

        #endregion

        #region IMsgReceiver接口

        public string ID { get; protected set; }

        public bool AllowReceiveMsg(uint msg)
        {
            return MsgHandlers.ContainsKey(msg);
        }

        public object ReceiveSync(Message msg)
        {
            if (msg != null)
            {
                if(MsgHandlers.ContainsKey(msg.Msg))
                    return MsgHandlers[msg.Msg](msg);

                if (MsgMethodInfos.ContainsKey(msg.Msg))
                    return MsgMethodInfos[msg.Msg].Invoke(new object[] { msg });
            }

            return null;
        }

        public void ReceiveAsync(Message msg)
        {
            if (msg == null) return;

            lock (MsgList.SyncRoot)
            {
                MsgList.Enqueue(msg);

                if (Handling)
                {
                    return;
                }

                Handling = true;
            }

            ThreadPool.QueueUserWorkItem(new WaitCallback(MsgHandle), this);
        }

        private static void MsgHandle(object state)
        {
            DefaultReceiver receiver = state as DefaultReceiver;
            Queue msgList = receiver.MsgList;
            lock (msgList.SyncRoot)
            {
                while (msgList.Count > 0)
                {
                    Message msg = msgList.Dequeue() as Message;
                    receiver.ReceiveSync(msg);
                }

                receiver.Handling = false;
            }
        }

        #endregion

        #region 预置消息处理函数

        //[MsgHandler(MsgType.Dispose, false, "释放消息")]
        protected virtual object Dispose(Message msg)
        {
            MsgMonitor.RemoveReceiver(ID);
            return null;
        }

        #endregion
    }
}
