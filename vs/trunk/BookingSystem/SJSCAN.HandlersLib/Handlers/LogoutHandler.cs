using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.LOGOUT, "注销登陆")]
    public class LogoutHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            if (PageUtils.IsLogined)
            {
                LoginAjaxHandler.Logined(new User());
                responder.WriteSuccessedMsg("注销登陆成功!");
                return;
            }

            responder.WriteErroredMsg("当前未登陆或已注销!");
        }
    }
}
