using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.JOINBOOKING, "加入预订")]
    public class JoinBookingHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            Bookingshop bookingshop = new Bookingshop();

            bookingshop.Bookingid = SJSRequest.GetInt("Bookingid", 0);
            bookingshop.Bookingname = SJSRequest.GetString("Bookingname");
            bookingshop.Shopid = SJSRequest.GetInt("Shopid", 0);
            bookingshop.Shopname = SJSRequest.GetString("Shopname");
            bookingshop.Uid = PageUtils.AccountID;
            bookingshop.Realname = PageUtils.RealName.Trim();
            bookingshop.Isover = false;
            //bookingshop.Begintime = DateTime.Now;// DateTime.UtcNow;

            if (bookingshop.Bookingid <= 0)
            {
                responder.WriteErroredMsg("预订参数错误!");
                return;
            }

            if (bookingshop.Shopid <= 0)
            {
                responder.WriteErroredMsg("店铺参数错误!");
                return;
            }

            Booking booking = BookingManager.GetBooking(bookingshop.Bookingid);

            if (booking == null)
            {
                responder.WriteErroredMsg("此预订不存在,无法加入!");
                return;
            }

            if (booking.Isbooking == false)
            {
                responder.WriteErroredMsg("此预订已结束,无法加入!");
                return;
            }

            Bookingshop confirm = BookingshopManager.GetBookingshop(bookingshop.Bookingid, bookingshop.Shopid, bookingshop.Uid);

            if (confirm != null)
            {
                responder.WriteErroredMsg("此店铺已存在于" + bookingshop.Bookingname + "的店铺列表,无法再次加入预订!");
                return;
            }

            bookingshop.Begintime = booking.Bookingtime;

            int rlt = BookingshopManager.AddBookingshop(bookingshop);

            if (rlt <= 0)
            {
                responder.WriteErroredMsg("店铺预订加入失败,数据库写入不成功!");
                return;
            }

            responder.WriteSuccessedMsg("加入预订成功!");
        }
    }
}
