using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.ADDBOOKING, "新建预订")]
    public class AddBookingHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            Booking booking = new Booking();
            booking.Bookingname = SJSRequest.GetString("Bookingname").Trim();
            DateTime dt = DateTime.Now;
            string dtStr = SJSRequest.GetString("Bookingtime");
            if (string.IsNullOrEmpty(dtStr) == false)
            {
                dt = Convert.ToDateTime(dtStr);
                dt = dt.AddHours(DateTime.Now.Hour).AddMinutes(DateTime.Now.Minute).AddSeconds(DateTime.Now.Second);
            }
            booking.Bookingtime = dt;// DateTime.UtcNow;
            booking.Isbooking = true;
            booking.Uid = PageUtils.AccountID;
            booking.Realname = PageUtils.RealName;
            booking.Issettle = false;
            booking.Haserror = false;

            if (string.IsNullOrEmpty(booking.Bookingname))
            {
                responder.WriteErroredMsg("预订名称不能为空!");
                return;
            }

            booking.Bookingname += "(" + booking.Bookingtime.Month + "-" + booking.Bookingtime.Day + ")";

            int rlt = BookingManager.AddBooking(booking);

            if (rlt <= 0)
            {
                responder.WriteErroredMsg("预订新建失败,数据库写入不成功!");
                return;
            }

            responder.WriteSuccessedMsg("新建预订成功!");
        }
    }
}
