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
    [AjaxHandler(eHandlerTypes.DELBOOKING, "删除预订")]
    public class DelBookingHandler : IAjaxHandler
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
                responder.WriteErroredMsg("不存在此预订,无法删除!");
                return;
            }

            if (booking.Issettle)
            {
                responder.WriteErroredMsg("此预订已结算,无法删除!");
                return;
            }

            using (DbTransaction trans = DbHelper.BeginTransaction())
            {
                bool writeError = false;
                try
                {
                    int rlt = BookingManager.DelBooking(id, trans);
                    if (rlt <= 0)
                    {
                        writeError = true;
                        trans.Rollback();
                        responder.WriteErroredMsg("删除预订失败,数据库更新不成功!");
                        return;
                    }

                    BookingshopManager.DelBookingshop(id, true, trans);

                    IList<Bookingtrade> list = BookingtradeManager.GetBookingtrade(id, trans, true);

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
                        deduction.Deductionname = string.Format("退订{0}(删除预订)", item.Tradename);
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
                    if(writeError == false) responder.WriteErroredMsg("删除失败,程序异常!");
                    return;
                }
            }

            responder.WriteSuccessedMsg("预订、此预订接受预订的店铺列表和此预订的预订记录删除成功!");
        }
    }
}
