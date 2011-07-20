using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.GETUSERINFO, "获取当前登陆用户信息")]
    public class GetUserInfoHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            string json = "{";

            if (PageUtils.IsLogined)
            {
                User user = UserManager.GetUser(PageUtils.AccountID);

                json += string.Format("用户类型:'{0}',", user.Type == (int)eAuthority.CommonUser ? "普通用户" : "管理员");
                json += string.Format("当前用户:'{0}',", user.Realname);
                json += string.Format("当前余额:'{0}'", user.Balance);

                json += "}";
            }
            else
            {
                json += string.Format("用户类型:'{0}',", "");
                json += string.Format("当前用户:'{0}',", "");
                json += string.Format("当前余额:'{0}'", "");

                json += "}";
            }

            responder.WriteSuccessed(json);
        }
    }
}
