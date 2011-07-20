using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.RESETPASSWD, "重置密码")]
    public class ResetPasswdHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            int uid = SJSRequest.GetInt("Uid", 0);
            if (uid <= 0)
            {
                responder.WriteErroredMsg("请求参数错误!");
                return;
            }

            string passwd = SJSRequest.GetString("NewPasswd");
            if (string.IsNullOrEmpty(passwd))
            {
                responder.WriteErroredMsg("密码不能为空");
                return;
            }

            User user = UserManager.GetUser(uid);

            if (user == null)
            {
                responder.WriteErroredMsg("找不到此用户,无法重置密码!");
                return;
            }

            user.Passwd = Utils.MD5(passwd);

            int rlt = UserManager.UpdateUser(user);

            if (rlt <= 0)
            {
                responder.WriteErroredMsg("密码重置失败,数据为更新不成功!");
            }
            else
            {
                responder.WriteSuccessedMsg("密码重置成功!");
            }
        }
    }
}
