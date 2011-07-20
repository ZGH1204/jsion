using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.GETBOOKINGSHOPLISTBYDATE, "根据日期获取当天所有预订店铺列表")]
    public class GetBookingShopListByDateHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            string dateStr = SJSRequest.GetString("Date");

            DateTime dt = DateTime.Now;

            if (string.IsNullOrEmpty(dateStr) == false)
            {
                dt = Convert.ToDateTime(dateStr);
            }
            //IList<Bookingshop> list = BookingshopManager.GetBookingshop(dt, PageUtils.AccountID);
            IList<Bookingshop> list = BookingshopManager.GetBookingshop(dt, 0);

            string json = PageUtils.TranformJSON(list);

            responder.WriteSuccessed(json);
        }
    }
}
