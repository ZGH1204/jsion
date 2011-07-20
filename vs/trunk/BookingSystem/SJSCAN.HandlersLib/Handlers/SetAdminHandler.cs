using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.SETADMIN, "设为管理员")]
    public class SetAdminHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            int uid = SJSRequest.GetInt("Uid", 0);

            if (uid <= 0)
            {
                responder.WriteErroredMsg("请求参数错误!");
                return;
            }

            User user = UserManager.GetUser(uid);

            if (user == null)
            {
                responder.WriteErroredMsg("此用户不存在,设置失败!");
                return;
            }

            if (user.Type == (int)eAuthority.AdminUser)
            {
                responder.WriteSuccessedMsg(user.Realname + "已经是管理员,请不要重复设置!");
                return;
            }

            user.Type = (int)eAuthority.AdminUser;

            int rlt = UserManager.UpdateUser(user);

            if (rlt <= 0)
            {
                responder.WriteErroredMsg("设置失败,数据库更新数据不成功!");
            }
            else
            {
                responder.WriteSuccessedMsg("设置成功!");
            }
        }
    }
}
