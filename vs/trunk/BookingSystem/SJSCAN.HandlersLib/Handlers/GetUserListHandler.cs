using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using SJSCAN.Entity;
using SJSCAN.BLL;
using Sjs.Common;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.GETUSERLIST, "获取用户列表")]
    public class GetUserListHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            IList<User> list = UserManager.GetUser();

            foreach (User item in list)
            {
                item.Passwd = "";
            }

            string json = PageUtils.TranformJSON(list);

            responder.WriteSuccessed(json);
        }
    }
}
