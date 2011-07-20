using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;
using System.Data.Common;
using Sjs.Data;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.BOOKINGONLINE, "在线预订提交")]
    public class BookingOnlineHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            int withUid = SJSRequest.GetInt("WithUid", 0);
            Bookingtrade bookingtrade = new Bookingtrade();
            bookingtrade.Tradeid = SJSRequest.GetInt("Tradeid", 0);
            bookingtrade.Bookingshopid = SJSRequest.GetInt("Id", 0);
            bookingtrade.Tradecount = SJSRequest.GetInt("Tradecount", 0);
            //bookingtrade.Remarks = SJSRequest.GetString("Remarks");

            if (bookingtrade.Tradecount <= 0)
            {
                responder.WriteErroredMsg("预订数量只能是正数!");
                return;
            }

            if (bookingtrade.Tradeid <= 0)
            {
                responder.WriteErroredMsg("菜单项请求参数错误!");
                return;
            }

            if (bookingtrade.Bookingshopid <= 0)
            {
                responder.WriteErroredMsg("预订店铺记录请求参数错误!");
                return;
            }

            Bookingshop bookingshop = BookingshopManager.GetBookingshop(bookingtrade.Bookingshopid);

            if (bookingshop == null)
            {
                responder.WriteErroredMsg("此店铺接受预订记录不存在,无法预订!");
                return;
            }

            Booking booking = BookingManager.GetBooking(bookingshop.Bookingid);

            if (booking == null)
            {
                responder.WriteErroredMsg("此预订不存在,无法预订!");
                return;
            }

            if (booking.Isbooking == false && User.IsAdministrator(PageUtils.Utype) == false)
            {
                responder.WriteErroredMsg("此预订已结束,无法预订!");
                return;
            }

            Trade trade = TradeManager.GetTrade(bookingtrade.Tradeid);

            if (trade == null)
            {
                responder.WriteErroredMsg("不存在此菜单项,无法预订!");
                return;
            }

            IList<Bookingtrade> confirmList = BookingtradeManager.GetBookingtrade(bookingshop.Id, trade.Id, true);

            Bookingtrade confirm = null;

            int uid = PageUtils.AccountID;
            string rname = PageUtils.RealName;

            for (int i = 0; i < confirmList.Count; i++)
            {
                if (withUid > 0 && withUid == confirmList[i].Uid)
                {
                    confirm = confirmList[i];
                    break;
                }

                if (withUid <= 0 && uid == confirmList[i].Uid)
                {
                    confirm = confirmList[i];
                    break;
                }
            }

            int rlt = 0;
            bool isAdd = false;

            using (DbTransaction trans = DbHelper.BeginTransaction())
            {
                bool writeError = false;
                try
                {
                    User user = null;
                    Deduction deduction = new Deduction();
                    int addedCount = 0;
                    if (confirm != null && (withUid <= 0 || withUid == confirm.Uid))
                    {
                        addedCount = bookingtrade.Tradecount;

                        user = UserManager.GetUser(confirm.Uid, trans);

                        if (user == null)
                        {
                            writeError = true;
                            trans.Rollback();
                            responder.WriteErroredMsg("不存在此用户,无法预订!");
                            return;
                        }


                        if (user.Enabled == false)
                        {
                            writeError = true;
                            trans.Rollback();
                            responder.WriteErroredMsg(user.Realname + " 处于禁用状态,无法预订!");
                            return;
                        }


                        uid = user.Uid;
                        rname = user.Realname;

                        deduction.Deductionbalance = user.Balance - confirm.Tradevalue * addedCount;
                        deduction.Deductioncount = addedCount;
                        deduction.Deductionname = string.Format("预订{0}", confirm.Tradename);
                        deduction.Deductiontime = DateTime.Now;
                        deduction.Deductionvalue = -confirm.Tradevalue * addedCount;
                        deduction.Uid = confirm.Uid;
                        deduction.Realname = confirm.Realname;
                        deduction.Shopid = confirm.Shopid;
                        deduction.Shopname = confirm.Shopname;
                        deduction.Remarks = confirm.Remarks;

                        confirm.Tradecount += addedCount;
                        bookingtrade = confirm;

                        isAdd = false;
                    }
                    else
                    {
                        if (withUid > 0 && uid != withUid)
                            user = UserManager.GetUser(withUid, trans);
                        else
                            user = UserManager.GetUser(uid, trans);

                        if (user == null)
                        {
                            writeError = true;
                            trans.Rollback();
                            responder.WriteErroredMsg("不存在此用户,无法预订!");
                            return;
                        }


                        if (user.Enabled == false)
                        {
                            writeError = true;
                            trans.Rollback();
                            responder.WriteErroredMsg(user.Realname + " 处于禁用状态,无法预订!");
                            return;
                        }


                        if (withUid > 0)
                        {
                            bookingtrade.Proxyid = uid;
                            bookingtrade.Proxyname = rname;
                            bookingtrade.Remarks += string.Format("由 {0} 代订", rname.Trim());
                        }

                        uid = user.Uid;
                        rname = user.Realname;

                        bookingtrade.Bookingid = booking.Id;
                        bookingtrade.Bookingname = booking.Bookingname;
                        bookingtrade.Handlerid = bookingshop.Uid;
                        bookingtrade.Handlername = bookingshop.Realname;
                        bookingtrade.Uid = uid;
                        bookingtrade.Realname = rname;
                        bookingtrade.Shopid = bookingshop.Shopid;
                        bookingtrade.Shopname = bookingshop.Shopname;
                        bookingtrade.Tradename = trade.Tradename;
                        bookingtrade.Tradevalue = trade.Tradevalue;
                        bookingtrade.Issettle = booking.Isbooking == false;
                        bookingtrade.Bookinttime = DateTime.Now;

                        if (booking.Bookingtime.Date.Equals(DateTime.Now.Date) == false)
                        {
                            bookingtrade.Bookinttime = new DateTime(booking.Bookingtime.Date.Ticks);
                            bookingtrade.Bookinttime = bookingtrade.Bookinttime.AddHours(DateTime.Now.Hour).AddMinutes(DateTime.Now.Minute).AddSeconds(DateTime.Now.Second);
                        }

                        addedCount = bookingtrade.Tradecount;
                        deduction.Deductionbalance = user.Balance - trade.Tradevalue * addedCount;
                        deduction.Deductioncount = addedCount;
                        deduction.Deductionname = string.Format("预订{0}", bookingtrade.Tradename);
                        deduction.Deductiontime = DateTime.Now;
                        deduction.Deductionvalue = -bookingtrade.Tradevalue * addedCount;
                        deduction.Uid = bookingtrade.Uid;
                        deduction.Realname = bookingtrade.Realname;
                        deduction.Shopid = bookingtrade.Shopid;
                        deduction.Shopname = bookingtrade.Shopname;
                        deduction.Remarks = bookingtrade.Remarks;

                        isAdd = true;
                    }

                    rlt = UserManager.UpdateUserBalance(uid, trade.Tradevalue * addedCount, trans);
                    if (rlt <= 0)
                    {
                        writeError = true;
                        trans.Rollback();
                        responder.WriteErroredMsg("扣除余额失败,数据库更新不成功!");
                        return;
                    }

                    rlt = DeductionManager.AddDeduction(deduction, trans);
                    if (rlt <= 0)
                    {
                        writeError = true;
                        trans.Rollback();
                        responder.WriteErroredMsg("扣款记录失败,数据库写入不成功!");
                        return;
                    }

                    if (isAdd)
                    {
                        rlt = BookingtradeManager.AddBookingtrade(bookingtrade, trans);
                    }
                    else
                    {
                        rlt = BookingtradeManager.UpdateBookingtrade(bookingtrade, trans);
                    }

                    trans.Commit();
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    if (writeError == false)
                    {
                        responder.WriteErroredMsg("预订失败,程序异常!");
                    }
                    return;
                }
            }

            if (rlt <= 0)
            {
                if(isAdd)
                    responder.WriteErroredMsg("预订失败,数据库写入不成功!");
                else
                    responder.WriteErroredMsg("预订失败,数据库更新不成功!");

                return;
            }

            if (isAdd)
                responder.WriteSuccessedMsg("提交成功,预订项已添加!");
            else
                responder.WriteSuccessedMsg("提交成功,预订项已更新!");
        }
    }
}
