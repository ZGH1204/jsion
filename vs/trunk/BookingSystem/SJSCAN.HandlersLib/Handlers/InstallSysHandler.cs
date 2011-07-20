using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.INSTALLSYS, "初始化系统")]
    public class InstallSysHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            IList<App> list = AppManager.GetApp();

            if (list.Count > 0)
            {
                responder.WriteErroredMsg("系统已初始化,请不要重复初始化!");
                return;
            }

            App app = new App();

            app.Isinstall = true;

            app.Id = AppManager.AddApp(app);
            if (app.Id <= 0)
            {
                responder.WriteErroredMsg("初始化失败,系统写入失败!");
                return;
            }

            User user = new User();

            user.Account = SJSRequest.GetString("Account").Trim();
            user.Passwd = SJSRequest.GetString("Passwd");
            user.Realname = SJSRequest.GetString("Realname");
            user.Balance = 0;
            user.Type = (int)eAuthority.AdminUser;


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
                LoginAjaxHandler.Logined(user);
                responder.WriteSuccessedMsg("初始化成功!");
            }
            else
            {
                responder.WriteErroredMsg("初始化失败,数据库写入不成功!");
            }
        }
    }
}
