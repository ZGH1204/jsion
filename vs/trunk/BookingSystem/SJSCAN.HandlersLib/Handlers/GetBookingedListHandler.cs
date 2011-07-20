using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.GETBOOKINGEDLIST, "获取指定预订的所有预订列表")]
    public class GetBookingedListHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            int bookingshopid = SJSRequest.GetInt("Bookingshopid", 0);

            //IList<Bookingtrade> list = BookingtradeManager.GetBookingtrade(bookingshopid, PageUtils.AccountID, 0);
            IList<Bookingtrade> list = BookingtradeManager.GetBookingtrade(bookingshopid, 0, 0);

            string json = PageUtils.TranformJSON(list);

            responder.WriteSuccessed(json);
        }
    }
}
