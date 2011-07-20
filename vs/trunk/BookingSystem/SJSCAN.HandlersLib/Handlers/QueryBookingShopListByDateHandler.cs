using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.QUERYBOOKINGSHOPLISTBYDATE, "查询指定日期的预订记录")]
    public class QueryBookingShopListByDateHandler:IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            string dateStr = SJSRequest.GetString("Date");

            DateTime dt = DateTime.Now;

            if (string.IsNullOrEmpty(dateStr) == false)
            {
                dt = Convert.ToDateTime(dateStr);
            }

            IList<Bookingshop> list = BookingshopManager.GetBookingshop(dt, 0);

            string json = PageUtils.TranformJSON(list);

            responder.WriteSuccessed(json);
        }
    }
}
