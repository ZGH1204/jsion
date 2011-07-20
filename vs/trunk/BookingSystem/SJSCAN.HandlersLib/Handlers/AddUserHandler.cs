using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.ADDUSER, "新增用户")]
    public class AddUserHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            string isAdmin = SJSRequest.GetString("IsAdmin");
            User user = new User();
            user.Uid = 0;
            user.Account = SJSRequest.GetString("Account").Trim();
            user.Passwd = SJSRequest.GetString("Passwd");
            user.Realname = SJSRequest.GetString("Realname");
            user.Balance = 0;
            user.Type = (isAdmin == "on" ? (int)eAuthority.AdminUser : (int)eAuthority.CommonUser);

            if (string.IsNullOrEmpty(user.Account))
            {
                responder.WriteErroredMsg("帐号不能为空");
                return;
            }

            if (string.IsNullOrEmpty(user.Passwd))
            {
                responder.WriteErroredMsg("密码不能为空");
                return;
            }
            else
            {
                user.Passwd = Utils.MD5(user.Passwd);
            }

            User confirm = UserManager.GetUser(user.Account);
            if (confirm != null)
            {
                responder.WriteErroredMsg("此用户名已存在!");
                return;
            }

            user.Uid = UserManager.AddUser(user);

            if (user.Uid > 0)
            {
                responder.WriteSuccessedMsg("新增用户成功!");
            }
            else
            {
                responder.WriteErroredMsg("新增用户失败,数据库写入不成功!");
            }
        }
    }
}
