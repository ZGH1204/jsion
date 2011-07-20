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
    [AjaxHandler(eHandlerTypes.CANCELBOOKINGED, "取消预订")]
    public class CancelBookingedHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            int bookingtradeid = SJSRequest.GetInt("Id", 0);
            int tradecount = SJSRequest.GetInt("Tradecount", 0);

            if (bookingtradeid <= 0)
            {
                responder.WriteErroredMsg("请求参数错误!");
                return;
            }

            if (tradecount <= 0)
            {
                responder.WriteErroredMsg("取消数量应为正数!");
                return;
            }

            Bookingtrade bookingtrade = BookingtradeManager.GetBookingtrade(bookingtradeid);

            if (bookingtrade == null)
            {
                responder.WriteErroredMsg("不存在此预订项,无法取消!");
                return;
            }

            Booking booking = BookingManager.GetBooking(bookingtrade.Bookingid);

            if (booking == null)
            {
                responder.WriteErroredMsg("此预订不存在或已被删除,无法取消!");
                return;
            }

            if (booking.Isbooking == false && User.IsAdministrator(PageUtils.Utype) == false)
            {
                responder.WriteErroredMsg("此预订已结束,无法取消!");
                return;
            }
            int rlt = 0;
            using (DbTransaction trans = DbHelper.BeginTransaction())
            {
                bool writeError = false;
                try
                {
                    int hasCount = bookingtrade.Tradecount;

                    bookingtrade.Tradecount = Math.Max(0, bookingtrade.Tradecount - tradecount);
                    tradecount = hasCount - bookingtrade.Tradecount;

                    if (bookingtrade.Uid != PageUtils.AccountID)
                    {
                        bookingtrade.Remarks += string.Format(" 由{0}退订{1}份", PageUtils.RealName, tradecount);
                    }

                    User user = UserManager.GetUser(bookingtrade.Uid, trans);

                    rlt = UserManager.UpdateUserBalance(bookingtrade.Uid, -bookingtrade.Tradevalue * tradecount, trans);
                    if (rlt <= 0)
                    {
                        writeError = true;
                        trans.Rollback();
                        responder.WriteErroredMsg("返还余额失败,数据库更新不成功!");
                        return;
                    }

                    Deduction deduction = new Deduction();
                    deduction.Deductionbalance = user.Balance + bookingtrade.Tradevalue * tradecount;
                    deduction.Deductioncount = -tradecount;
                    deduction.Deductionname = string.Format("取消{0}", bookingtrade.Tradename);
                    deduction.Deductiontime = DateTime.Now;
                    deduction.Deductionvalue = bookingtrade.Tradevalue * tradecount;
                    deduction.Uid = bookingtrade.Uid;
                    deduction.Realname = bookingtrade.Realname;
                    deduction.Shopid = bookingtrade.Shopid;
                    deduction.Shopname = bookingtrade.Shopname;
                    deduction.Remarks = bookingtrade.Remarks;
                    rlt = DeductionManager.AddDeduction(deduction, trans);
                    if (rlt <= 0)
                    {
                        writeError = true;
                        trans.Rollback();
                        responder.WriteErroredMsg("返还余额失败,数据库更新不成功!");
                        return;
                    }

                    if (bookingtrade.Tradecount > 0)
                    {
                        rlt = BookingtradeManager.UpdateBookingtrade(bookingtrade, trans);
                    }
                    else
                    {
                        rlt = BookingtradeManager.DelBookingtrade(bookingtrade.Id, trans);
                    }

                    if (rlt <= 0)
                    {
                        writeError = true;
                        trans.Rollback();
                        responder.WriteErroredMsg("取消预订失败,数据库更新不成功!");
                        return;
                    }

                    trans.Commit();
                }
                catch (Exception ex)
                {
                    trans.Rollback();

                    if (writeError == false)
                    {
                        responder.WriteErroredMsg("取消失败,程序异常!");
                    }
                    return;
                }
            }

            responder.WriteSuccessedMsg(string.Format("成功取消{0}个预订", tradecount));
        }
    }
}
