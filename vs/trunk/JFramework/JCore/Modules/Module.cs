using System;
using System.Collections.Generic;
using System.Text;

using JUtils.Messages;
using System.Threading;

namespace JCore.Modules
{
    public class Module : IMsgReceiver
    {
        public object lockHelper = new object();

        protected List<Message> msgQueue = new List<Message>();

        protected bool hasMsgInQueue = false;

        protected Dictionary<uint, MsgAction<Message>> msgHandlers = new Dictionary<uint, MsgAction<Message>>();

        public ModuleInfo ModuleInfo { get; private set; }

        public Module(ModuleInfo moduleinfo)
        {
            ModuleInfo = moduleinfo;
        }

        public string ID
        {
            get { return ModuleInfo.ID; }
        }

        protected virtual void Install()
        {
        }

        protected virtual void Uninstall()
        {
        }


        public bool AllowReceiveMsg(uint msg)
        {
            return msgHandlers.ContainsKey(msg);
        }

        public object ReceiveSync(Message msg)
        {
            if (msgHandlers.ContainsKey(msg.Msg))
            {
                return msgHandlers[msg.Msg](msg);
            }

            return null;
        }

        public void ReceiveAsync(Message msg)
        {
            if (msg == null) return;

            msgQueue.Add(msg);

            if (hasMsgInQueue == false)
            {
                hasMsgInQueue = true;
                ThreadPool.QueueUserWorkItem(new WaitCallback(AsyncHandleMsg), this);
            }
        }

        private static void AsyncHandleMsg(object state)
        {
            Module module = state as Module;

            if (module == null) return;

            lock (module.lockHelper)
            {
                while (module.msgQueue.Count > 0)
                {
                    Message msg = module.msgQueue[0];

                    module.msgQueue.RemoveAt(0);

                    module.ReceiveSync(msg);
                }

                module.hasMsgInQueue = false;
            }
        }
    }
}
