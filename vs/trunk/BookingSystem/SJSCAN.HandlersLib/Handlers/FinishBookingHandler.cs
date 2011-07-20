using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.FINISHBOOKING, "结束预订")]
    public class FinishBookingHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            int id = SJSRequest.GetInt("Id", 0);

            if (id <= 0)
            {
                responder.WriteErroredMsg("请求参数错误!");
                return;
            }

            Booking booking = BookingManager.GetBooking(id);

            if (booking == null)
            {
                responder.WriteErroredMsg("不存在此预订, 无法结束预订!");
                return;
            }

            if (booking.Isbooking == false)
            {
                responder.WriteErroredMsg("此预订已经结束,无法重复结束!");
                return;
            }

            if (booking.Uid != PageUtils.AccountID)
            {
                responder.WriteErroredMsg("没有权限结束其他人的预订!");
                return;
            }

            booking.Isbooking = false;

            int rlt = BookingManager.UpdateBooking(booking);

            if (rlt <= 0)
            {
                responder.WriteErroredMsg("结束预订失败,数据库更新不成功!");
                return;
            }

            IList<Bookingshop> list = BookingshopManager.GetBookingshop(booking.Id, true);

            foreach (Bookingshop item in list)
            {
                item.Isover = true;
                BookingshopManager.UpdateBookingshop(item);
            }

            BookingtradeManager.UpdateBookingtrade(booking.Id, !booking.Isbooking);

            responder.WriteSuccessedMsg("结束预订成功!");
        }
    }
}
