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
    [AjaxHandler(eHandlerTypes.DELBOOKINGSHOP, "删除接受预订的店铺")]
    public class DelBookingShopHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            int id = SJSRequest.GetInt("Id", 0);

            if (id <= 0)
            {
                responder.WriteErroredMsg("请求参数错误!");
                return;
            }

            Bookingshop bookingshop = BookingshopManager.GetBookingshop(id);

            if (bookingshop == null)
            {
                responder.WriteErroredMsg("接受预订的店铺列表不存在此店铺,无法删除!");
                return;
            }

            Booking booking = BookingManager.GetBooking(bookingshop.Bookingid);

            if (booking != null)
            {
                if (booking.Isbooking == false)
                {
                    responder.WriteErroredMsg("此预订已结束,无法删除!");
                    return;
                }
            }

            if (bookingshop.Uid != PageUtils.AccountID)
            {
                responder.WriteErroredMsg("店铺删除失败,不是本人开启的预订没有权限进行此操作!");
                return;
            }

            using (DbTransaction trans = DbHelper.BeginTransaction())
            {
                bool writeError = false;
                try
                {
                    int rlt = BookingshopManager.DelBookingshop(id, trans);
                    if (rlt <= 0)
                    {
                        writeError = true;
                        trans.Rollback();
                        responder.WriteErroredMsg("店铺删除失败,数据库更新不成功!");
                        return;
                    }

                    IList<Bookingtrade> list = BookingtradeManager.GetBookingtrade(id, trans);

                    foreach (Bookingtrade item in list)
                    {
                        User user = UserManager.GetUser(item.Uid, trans);
                        user.Balance = user.Balance + item.Tradevalue * item.Tradecount;

                        rlt = UserManager.UpdateUserBalance(item.Uid, -item.Tradevalue * item.Tradecount, trans);
                        if (rlt <= 0)
                        {
                            writeError = true;
                            trans.Rollback();
                            responder.WriteErroredMsg("返还余额失败,数据库更新不成功!");
                            return;
                        }

                        Deduction deduction = new Deduction();
                        deduction.Deductionbalance = user.Balance;
                        deduction.Deductioncount = -item.Tradecount;
                        deduction.Deductionname = string.Format("退订{0}(删除接受预订的店铺)", item.Tradename);
                        deduction.Deductiontime = DateTime.Now;
                        deduction.Deductionvalue = item.Tradevalue * item.Tradecount;
                        deduction.Uid = item.Uid;
                        deduction.Realname = item.Realname;
                        deduction.Shopid = item.Shopid;
                        deduction.Shopname = item.Shopname;
                        deduction.Remarks = item.Remarks;

                        rlt = DeductionManager.AddDeduction(deduction, trans);

                        if (rlt <= 0)
                        {
                            writeError = true;
                            trans.Rollback();
                            responder.WriteErroredMsg("扣款记录失败,数据库写入不成功!");
                            return;
                        }

                        rlt = BookingtradeManager.DelBookingtrade(item.Id, trans);
                        if (rlt <= 0)
                        {
                            writeError = true;
                            trans.Rollback();
                            responder.WriteErroredMsg("删除已预订列表失败,数据库更新不成功!");
                            return;
                        }
                    }

                    trans.Commit();
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    if (writeError == false) responder.WriteErroredMsg("删除失败,程序异常!");
                    return;
                }
            }
            responder.WriteSuccessedMsg("店铺和预订此店铺的记录删除成功!");
        }
    }
}
