using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.GETBOOKINGLISTBYDATE, "根据日期获取当天所有预订列表")]
    public class GetBookingListByDateHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            string dateStr = SJSRequest.GetString("Date");

            DateTime dt = DateTime.Now;

            if (string.IsNullOrEmpty(dateStr) == false)
            {
                dt = Convert.ToDateTime(dateStr);
            }

            IList<Booking> list = BookingManager.GetBooking(dt, PageUtils.AccountID);

            string json = PageUtils.TranformJSON(list);

            responder.WriteSuccessed(json);
        }
    }
}
