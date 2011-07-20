using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using log4net;
using System.Reflection;

namespace JsionFramework.Jsion.WeakRefs
{
    public class WeakMulticastDelegate
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private WeakReference weakRef = null;

        private MethodInfo method = null;

        private WeakMulticastDelegate prev = null;

        public WeakMulticastDelegate(Delegate realDelegate)
        {
            if (realDelegate.Target != null)
            {
                this.weakRef = new WeakRef(realDelegate.Target);
            }

            this.method = realDelegate.Method;
        }

        public static WeakMulticastDelegate Combine(WeakMulticastDelegate weakDelegate, Delegate realDelegate)
        {
            if (realDelegate == null) return null;
            if (weakDelegate == null) return new WeakMulticastDelegate(realDelegate);
            return weakDelegate.Combine(realDelegate);
        }

        public static WeakMulticastDelegate CombineUnique(WeakMulticastDelegate weakDelegate, Delegate realDelegate)
        {
            if (realDelegate == null) return null;
            if (weakDelegate == null) return new WeakMulticastDelegate(realDelegate);
            return weakDelegate.CombineUnique(realDelegate);
        }

        public static WeakMulticastDelegate Remove(WeakMulticastDelegate weakDelegate, Delegate realDelegate)
        {
            if (realDelegate == null || weakDelegate == null) return null;
            return weakDelegate.Remove(realDelegate);
        }

        public WeakMulticastDelegate Combine(Delegate realDelegate)
        {
            WeakMulticastDelegate head = new WeakMulticastDelegate(realDelegate);

            head.prev = this.prev;

            this.prev = head;

            return this;
        }

        public WeakMulticastDelegate CombineUnique(Delegate realDelegate)
        {
            bool found = Equals(realDelegate);

            if (!found && prev != null)
            {
                WeakMulticastDelegate curNode = prev;
                while (!found && curNode != null)
                {
                    if (curNode.Equals(realDelegate))
                    {
                        found = true;
                    }
                    curNode = curNode.prev;
                }
            }

            return found ? this : this.Combine(realDelegate);
        }

        public WeakMulticastDelegate Remove(Delegate realDelegate)
        {
            if (Equals(realDelegate))
            {
                return this.prev;
            }

            WeakMulticastDelegate current = this.prev;
            WeakMulticastDelegate last = this;

            while (current != null)
            {
                if (current.Equals(realDelegate))
                {
                    last.prev = current.prev;
                    current.prev = null;
                    break;
                }
                last = current;
                current = current.prev;
            }

            return this;
        }

        protected bool Equals(Delegate realDelegate)
        {
            if (weakRef == null)
            {
                if (realDelegate.Target == null && method == realDelegate.Method) return true;
                return false;
            }

            if (weakRef.Target == realDelegate.Target && method == realDelegate.Method) return true;
            return false;
        }

        public static WeakMulticastDelegate operator +(WeakMulticastDelegate d, Delegate realD)
        {
            return WeakMulticastDelegate.Combine(d, realD);
        }

        public static WeakMulticastDelegate operator -(WeakMulticastDelegate d, Delegate realD)
        {
            return WeakMulticastDelegate.Remove(d, realD);
        }




        public void Invoke(object[] args)
        {
            WeakMulticastDelegate current = this;
            int start;
            while (current != null)
            {
                start = Environment.TickCount;

                if (current.weakRef == null)
                {
                    current.method.Invoke(null, args);
                }
                else if (current.weakRef.IsAlive)
                {
                    current.method.Invoke(current.weakRef.Target, args);
                }

                if ((Environment.TickCount - start) > 500)
                {
                    if (log.IsWarnEnabled) log.Warn("WeakMulticastDelegate Invoke took " + (Environment.TickCount - start) + "ms.|" + current.ToString());
                }

                current = current.prev;
            }
        }

        public void InvokeSafe(object[] args)
        {
            WeakMulticastDelegate current = this;
            int start;
            while (current != null)
            {
                start = Environment.TickCount;

                try
                {
                    if (current.weakRef == null)
                    {
                        current.method.Invoke(null, args);
                    }
                    else if (current.weakRef.IsAlive)
                    {
                        current.method.Invoke(current.weakRef.Target, args);
                    }
                }
                catch (Exception ex)
                {
                    if (log.IsErrorEnabled) log.Error("WeakMulticastDelegate InvokeSafe error.", ex);
                }

                if ((Environment.TickCount - start) > 500)
                {
                    if (log.IsWarnEnabled) log.Warn("WeakMulticastDelegate Invoke took " + (Environment.TickCount - start) + "ms.|" + current.ToString());
                }

                current = current.prev;
            }
        }




        /// <summary>
        /// Dumps the delegates in this multicast delegate to a string
        /// </summary>
        /// <returns>The string containing the formated dump</returns>
        public string Dump()
        {
            StringBuilder builder = new StringBuilder();
            WeakMulticastDelegate current = this;
            int count = 0;
            while (current != null)
            {
                count++;
                if (current.weakRef == null)
                {
                    builder.Append("\t");
                    builder.Append(count);
                    builder.Append(") ");
                    builder.Append(current.method.Name);
                    builder.Append(System.Environment.NewLine);
                }
                else
                {
                    if (current.weakRef.IsAlive)
                    {
                        builder.Append("\t");
                        builder.Append(count);
                        builder.Append(") ");
                        builder.Append(current.weakRef.Target);
                        builder.Append(".");
                        builder.Append(current.method.Name);
                        builder.Append(Environment.NewLine);
                    }
                    else
                    {
                        builder.Append("\t");
                        builder.Append(count);
                        builder.Append(") INVALID.");
                        builder.Append(current.method.Name);
                        builder.Append(Environment.NewLine);
                    }
                }
                current = current.prev;
            }
            return builder.ToString();
        }

        /// <summary>
        /// Gets string representation of delegate
        /// </summary>
        /// <returns></returns>
        override public string ToString()
        {
            Type declaringType = null;
            if (method != null)
                declaringType = method.DeclaringType;

            object target = null;
            if (weakRef != null && weakRef.IsAlive)
                target = weakRef.Target;

            return new StringBuilder(64)
                .Append("method: ").Append(declaringType == null ? "(null)" : declaringType.FullName)
                .Append('.').Append(method == null ? "(null)" : method.Name)
                .Append(" target: ").Append(target == null ? "null" : target.ToString())
                .ToString();
        }
    }
}
