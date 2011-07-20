using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.QUERYBOOKINGEDLIST, "查询已预订菜单")]
    public class QueryBookingedListHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            int bookingshopid = SJSRequest.GetInt("Bookingshopid", 0);

            IList<Bookingtrade> list = BookingtradeManager.GetBookingtrade(bookingshopid, 0, 0);

            string json = PageUtils.TranformJSON(list);

            responder.WriteSuccessed(json);
        }
    }
}
