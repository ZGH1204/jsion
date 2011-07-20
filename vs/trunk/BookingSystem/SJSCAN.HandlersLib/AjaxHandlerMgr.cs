using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using System.Reflection;

namespace SJSCAN.HandlersLib
{
    public class AjaxHandlerMgr
    {
        private AjaxHandlerMgr()
        {
            setup();
        }

        private static AjaxHandlerMgr _instance;
        private static object lockHelper = new object();

        private Dictionary<string, IAjaxHandler> handlers;

        private void setup()
        {
            handlers = new Dictionary<string, IAjaxHandler>();

            SearchAjaxHandlers(Assembly.GetAssembly(typeof(AttributeHelper)));
        }

        private void SearchAjaxHandlers(Assembly assembly)
        {
            handlers.Clear();

            Type[] types = assembly.GetTypes();

            foreach (Type type in types)
            {
                if (type.IsClass == false)
                    continue;
                if (type.GetInterface("SJSCAN.HandlersLib.Interfaces.IAjaxHandler") == null)
                    continue;

                AjaxHandlerAttribute[] attrs = (AjaxHandlerAttribute[])type.GetCustomAttributes(typeof(AjaxHandlerAttribute), true);

                if (attrs.Length > 0)
                {
                    RegisterHandler(attrs[0].Method, Activator.CreateInstance(type) as IAjaxHandler);
                }
            }
        }

        private void RegisterHandler(string key, IAjaxHandler handler)
        {
            handlers.Add(key, handler);
        }

        public IAjaxHandler loadHandler(string method)
        {
            try
            {
                return handlers[method];
            }
            catch
            {
                return null;
            }
        }

        public static AjaxHandlerMgr Instance
        {
            get
            {
                lock (lockHelper)
                {
                    if (_instance == null)
                    {
                        lock (lockHelper)
                        {
                            if (_instance == null)
                            {
                                _instance = new AjaxHandlerMgr();
                            }
                        }
                    }
                }

                return _instance;
            }
        }
    }
}
