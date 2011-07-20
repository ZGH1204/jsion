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
    [AjaxHandler(eHandlerTypes.RETURNCASH, "返还现金")]
    public class ReturnCashHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            int uid = SJSRequest.GetInt("Uid", 0);

            if (uid <= 0)
            {
                responder.WriteErroredMsg("请求参数错误!");
                return;
            }

            User user;

            using (DbTransaction trans = DbHelper.BeginTransaction())
            {
                bool writeError = false;
                try
                {
                    user = UserManager.GetUser(uid, trans);

                    if (user == null)
                    {
                        writeError = true;
                        trans.Rollback();
                        responder.WriteErroredMsg("不存在此用户,无法返还现金!");
                        return;
                    }

                    if (user.Balance == 0)
                    {
                        writeError = true;
                        trans.Rollback();
                        responder.WriteErroredMsg("返还失败,当前用户余额已为零!");
                        return;
                    }

                    if (user.Balance < 0)
                    {
                        writeError = true;
                        trans.Rollback();
                        responder.WriteErroredMsg("返还失败,欠费用户无法返还现金!");
                        return;
                    }

                    int rlt = UserManager.UpdateUserBalance(user.Uid, user.Balance, trans);
                    if (rlt <= 0)
                    {
                        writeError = true;
                        trans.Rollback();
                        responder.WriteErroredMsg("返还失败,余额清零不成功!");
                        return;
                    }

                    Deduction deduction = new Deduction();
                    deduction.Deductionbalance = 0;
                    deduction.Deductioncount = 1;
                    deduction.Deductionname = "返还现金";
                    deduction.Deductiontime = DateTime.Now;
                    deduction.Deductionvalue = user.Balance;
                    deduction.Uid = user.Uid;
                    deduction.Realname = user.Realname;
                    deduction.Shopid = 0;
                    deduction.Shopname = "余额清零";
                    deduction.Remarks = "余额清零";

                    rlt = DeductionManager.AddDeduction(deduction, trans);
                    if (rlt <= 0)
                    {
                        writeError = true;
                        trans.Rollback();
                        responder.WriteErroredMsg("返还失败,扣款记录不成功!");
                        return;
                    }

                    trans.Commit();
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    if (writeError == false)
                    {
                        responder.WriteErroredMsg("返还失败,程序异常");
                    }
                    return;
                }
            }


            responder.WriteSuccessedMsg(string.Format("返还现金成功,应返还金额:{0}元!", user.Balance));
        }
    }
}
