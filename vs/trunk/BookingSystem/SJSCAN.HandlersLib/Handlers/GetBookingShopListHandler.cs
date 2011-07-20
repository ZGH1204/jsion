using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.GETBOOKINGSHOPLIST, "接受预订的店铺列表")]
    public class GetBookingShopListHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            int bookingId = SJSRequest.GetInt("Bookingid", 0);

            //if (bookingId <= 0)
            //{
            //    responder.WriteErroredMsg("请求参数错误!");
            //    return;
            //}

            IList<Bookingshop> list = BookingshopManager.GetBookingshop(bookingId, true);

            string json = PageUtils.TranformJSON(list);

            responder.WriteSuccessed(json);
        }
    }
}
