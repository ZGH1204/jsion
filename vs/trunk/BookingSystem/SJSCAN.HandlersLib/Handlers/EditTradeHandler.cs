using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.EDITTRADE, "修改菜单")]
    public class EditTradeHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            int id = SJSRequest.GetInt("Id", 0);

            if (id <= 0)
            {
                responder.WriteErroredMsg("请求参数错误!");
                return;
            }

            Trade trade = TradeManager.GetTrade(id);

            if (trade == null)
            {
                responder.WriteErroredMsg("此菜单不存在,无法修改!");
                return;
            }

            int hasBookingCount = BookingshopManager.GetBookingshop(trade.Shopid, false, true);
            if (hasBookingCount > 0)
            {
                responder.WriteErroredMsg("此店铺正在接受预订,无法修改此菜单!");
                return;
            }

            trade.Tradename = SJSRequest.GetString("Tradename");
            trade.Tradevalue = SJSRequest.GetFloat("Tradevalue", 0);

            if (string.IsNullOrEmpty(trade.Tradename))
            {
                responder.WriteErroredMsg("菜单名称不能为空!");
                return;
            }

            int rlt = TradeManager.UpdateTrade(trade);

            if (rlt <= 0)
            {
                responder.WriteErroredMsg("菜单修改失败,数据库更新不成功!");
                return;
            }

            responder.WriteSuccessedMsg("修改菜单成功!");
        }
    }
}
