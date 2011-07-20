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
    [AjaxHandler(eHandlerTypes.USERBALANCE, "用户充值")]
    public class UserBalanceHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            int uid = SJSRequest.GetInt("Uid", 0);

            double balance = SJSRequest.GetFloat("Balancemoney", 0);
            string remarks = SJSRequest.GetString("Remarks");

            if (uid <= 0)
            {
                responder.WriteErroredMsg("请求参数错误!");
                return;
            }

            if (balance <= 0)
            {
                responder.WriteErroredMsg("充值金额不能小于或等于0!");
                return;
            }

            using (DbTransaction trans = DbHelper.BeginTransaction())
            {
                bool writeError = false;
                try
                {
                    User user = UserManager.GetUser(uid, trans);

                    if (user == null)
                    {
                        writeError = true;
                        trans.Rollback();
                        responder.WriteErroredMsg("此用户不存在,无法充值!");
                        return;
                    }

                    user.Balance += balance;

                    int rlt = UserManager.UpdateUserBalance(user.Uid, -balance, trans);

                    if (rlt <= 0)
                    {
                        writeError = true;
                        trans.Rollback();
                        responder.WriteErroredMsg("充值失败,数据库数据更新不成功!");
                        return;
                    }

                    Balance balances = new Balance();

                    balances.Uid = uid;
                    balances.Balances = balance;
                    balances.Remarks = remarks;
                    balances.Btime = DateTime.Now;// DateTime.UtcNow;

                    balances.Id = BalanceManager.AddBalance(balances, trans);

                    if (balances.Id <= 0)
                    {
                        writeError = true;
                        trans.Rollback();
                        responder.WriteErroredMsg(user.Realname + "充值记录失败!");
                        return;
                    }

                    trans.Commit();
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    if (writeError == false)
                    {
                        responder.WriteErroredMsg("充值失败,程序异常!");
                    }
                    return;
                }
            }

            responder.WriteSuccessedMsg("充值成功!");
        }
    }
}
