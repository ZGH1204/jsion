using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.BLL;
using SJSCAN.Entity;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.ENABLEUSER, "启用用户")]
    public class EnableUserHandler : IAjaxHandler
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
                responder.WriteErroredMsg("此用户不存在,无法禁用!");
                return;
            }

            if (user.Enabled)
            {
                responder.WriteErroredMsg("此用户当前为启用状态,无须更改!");
                return;
            }

            //if (user.Balance > 0)
            //{
            //    responder.WriteErroredMsg(string.Format("此用户还有余额{0}未返还,无法禁用!", user.Balance));
            //    return;
            //}
            //else if (user.Balance < 0)
            //{
            //    responder.WriteErroredMsg(string.Format("此用户欠费{0}元,无法禁用!", Math.Abs(user.Balance)));
            //    return;
            //}

            int rlt = UserManager.DisableUser(uid, false);

            if (rlt > 0)
            {
                responder.WriteSuccessedMsg("用户启用成功!");
            }
            else
            {
                responder.WriteErroredMsg("用户启用失败,数据库数据更新不成功");
            }
        }
    }
}
