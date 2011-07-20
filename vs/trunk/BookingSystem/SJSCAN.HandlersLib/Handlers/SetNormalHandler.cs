using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.SETNORMAL, "设置普通用户")]
    public class SetNormalHandler : IAjaxHandler
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

            if (user.Type == (int)eAuthority.CommonUser)
            {
                responder.WriteSuccessedMsg(user.Realname + "已经是普通用户,请不要重复设置!");
                return;
            }

            user.Type = (int)eAuthority.CommonUser;

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
