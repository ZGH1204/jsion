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
    [AjaxHandler(eHandlerTypes.DEDUCTION, "手动扣款")]
    public class DeductionHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            Deduction deduction = new Deduction();

            deduction.Uid = SJSRequest.GetInt("Uid", 0);
            deduction.Deductionname = SJSRequest.GetString("Deductionname");
            deduction.Deductionvalue = SJSRequest.GetInt("Deductionvalue", 0);
            deduction.Remarks = SJSRequest.GetString("Remarks");
            deduction.Shopid = 0;
            deduction.Shopname = "手动扣款";
            deduction.Deductiontime = DateTime.Now;
            deduction.Deductioncount = 1;
            //deduction.Realname = SJSRequest.GetString("Realname");
            //deduction.Deductionbalance = 

            if (deduction.Uid <= 0)
            {
                responder.WriteErroredMsg("请求参数错误!");
                return;
            }

            if (string.IsNullOrEmpty(deduction.Deductionname))
            {
                responder.WriteErroredMsg("扣款项目不能为空!");
                return;
            }

            if (deduction.Deductionvalue <= 0)
            {
                responder.WriteErroredMsg("扣款金额必须大于0!");
                return;
            }

            using (DbTransaction trans = DbHelper.BeginTransaction())
            {
                bool writeError = false;
                try
                {
                    User user = UserManager.GetUser(deduction.Uid, trans);
                    if (user == null)
                    {
                        writeError = true;
                        trans.Rollback();
                        responder.WriteErroredMsg("不存在此用户,无法扣款!");
                        return;
                    }

                    deduction.Realname = user.Realname;
                    deduction.Deductionbalance = user.Balance - deduction.Deductionvalue;

                    int rlt = UserManager.UpdateUserBalance(user.Uid, deduction.Deductionvalue, trans);
                    if (rlt <= 0)
                    {
                        writeError = true;
                        trans.Rollback();
                        responder.WriteErroredMsg("扣除余额失败,无法扣款!");
                        return;
                    }

                    rlt = DeductionManager.AddDeduction(deduction, trans);
                    if (rlt <= 0)
                    {
                        writeError = true;
                        trans.Rollback();
                        responder.WriteErroredMsg("扣款记录失败,无法扣款!");
                        return;
                    }

                    trans.Commit();
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    if (writeError == false)
                    {
                        responder.WriteErroredMsg("扣款失败,程序异常");
                    }
                    return;
                }
            }

            responder.WriteSuccessedMsg(string.Format("扣款成功,扣除金额:{0}元!", deduction.Deductionvalue));
        }
    }
}
