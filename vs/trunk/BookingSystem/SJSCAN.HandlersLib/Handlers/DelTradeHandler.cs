using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.DELTRADE, "删除菜单")]
    public class DelTradeHandler : IAjaxHandler
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
                responder.WriteErroredMsg("此菜单不存在,无法删除!");
                return;
            }

            int hasBookingCount = BookingshopManager.GetBookingshop(trade.Shopid, false, true);
            if (hasBookingCount > 0)
            {
                responder.WriteErroredMsg("此店铺正在接受预订,无法删除此菜单!");
                return;
            }

            int rlt = TradeManager.DelTrade(id);

            if (rlt <= 0)
            {
                responder.WriteErroredMsg("菜单删除失败,数据库数据更新不成功!");
                return;
            }

            responder.WriteSuccessedMsg("菜单删除成功!");
        }
    }
}
