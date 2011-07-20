using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.ADDTRADE, "新增菜单")]
    public class AddTradeHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            Trade trade = new Trade();

            trade.Shopid = SJSRequest.GetInt("Shopid", 0);
            trade.Tradename = SJSRequest.GetString("Tradename");
            trade.Tradevalue = SJSRequest.GetFloat("Tradevalue", 0);

            if (trade.Shopid <= 0)
            {
                responder.WriteErroredMsg("请求参数错误!");
                return;
            }

            if (string.IsNullOrEmpty(trade.Tradename))
            {
                responder.WriteErroredMsg("菜单名称不能为空!");
                return;
            }

            int rlt = TradeManager.AddTrade(trade);

            if (rlt <= 0)
            {
                responder.WriteErroredMsg("新增菜单失败,数据库写入不成功!");
                return;
            }

            responder.WriteSuccessedMsg("新增菜单成功!");
        }
    }
}
