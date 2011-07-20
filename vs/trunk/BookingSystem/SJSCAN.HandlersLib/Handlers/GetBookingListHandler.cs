using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.GETBOOKINGLIST, "获取正在预订的预订列表")]
    public class GetBookingListHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            string dateStr = SJSRequest.GetString("Date");

            DateTime dt = DateTime.Now;

            if (string.IsNullOrEmpty(dateStr) == false)
            {
                dt = Convert.ToDateTime(dateStr);
            }

            IList<Booking> list = BookingManager.GetBooking(true, PageUtils.AccountID, dt);

            string json = PageUtils.TranformJSON(list);

            responder.WriteSuccessed(json);
        }
    }
}
