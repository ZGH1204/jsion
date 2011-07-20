using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.LOGIN, "用户登陆")]
    public class LoginAjaxHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            string account = SJSRequest.GetString("Account");
            string passwd = SJSRequest.GetString("Passwd");

            passwd = Utils.MD5(passwd);

            User user = UserManager.GetUser(account);

            if (user == null)
            {
                responder.WriteErroredMsg("此用户不存在!");
                return;
            }

            if (user.Passwd.Trim() != passwd)
            {
                responder.WriteErroredMsg("密码错误!");
                return;
            }

            //if (user.Enabled == false)
            //{
            //    responder.WriteErroredMsg("用户处于禁用状态,无法登陆!");
            //    return;
            //}

            Logined(user);

            responder.WriteSuccessedMsg("登陆成功");
        }

        public static void Logined(User user)
        {
            PageUtils.AccountID = user.Uid;
            PageUtils.Account = user.Account;
            PageUtils.RealName = user.Realname;
            PageUtils.Utype = user.Type;
        }
    }
}
