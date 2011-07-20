using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.GETBOOKINGSHOPONLINELIST, "获取指定日期当天正在预订的预订列表")]
    public class GetBookingshopOnlineListHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            string dateStr = SJSRequest.GetString("Date");

            DateTime dt = DateTime.Now;

            if (string.IsNullOrEmpty(dateStr) == false)
            {
                dt = Convert.ToDateTime(dateStr);
            }

            IList<Bookingshop> list;

            if (User.IsAdministrator(PageUtils.Utype))
            {
                list = BookingshopManager.GetBookingshop(dt);
            }
            else
            {
                list = BookingshopManager.GetBookingshop(dt, false);
            }

            string json = PageUtils.TranformJSON(list);

            responder.WriteSuccessed(json);
        }
    }
}
