using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.DELUSER, "删除用户")]
    public class DelUserHandler : IAjaxHandler
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
                responder.WriteErroredMsg("此用户不存在,无法删除!");
                return;
            }

            if (user.Balance > 0)
            {
                responder.WriteErroredMsg(string.Format("此用户还有余额{0}未返还,无法删除!", user.Balance));
                return;
            }
            else if (user.Balance < 0)
            {
                responder.WriteErroredMsg(string.Format("此用户欠费{0}元,无法删除!", Math.Abs(user.Balance)));
                return;
            }

            int rlt = UserManager.DelUser(uid);

            if (rlt > 0)
            {
                responder.WriteSuccessedMsg("用户删除成功!");
            }
            else
            {
                responder.WriteErroredMsg("用户删除失败,删除数据库数据不成功");
            }
        }
    }
}
