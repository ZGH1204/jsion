using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.GETCURRENTBOOKINGEDLIST, "获取今日预订列表")]
    public class GetCurrentBookingedListHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            DateTime dt = DateTime.Now;

            int uid = PageUtils.AccountID;

            if (uid <= 0)
            {
                uid = -1;
            }

            IList<Bookingtrade> list = BookingtradeManager.GetBookingtrade(uid, dt);

            string json = PageUtils.TranformJSON(list);

            responder.WriteSuccessed(json);
        }
    }
}
