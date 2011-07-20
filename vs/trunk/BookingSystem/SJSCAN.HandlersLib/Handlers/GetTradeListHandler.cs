using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.GETTRADELIST, "获取菜单列表")]
    public class GetTradeListHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            int shopid = SJSRequest.GetInt("Id", 0);

            IList<Trade> list = TradeManager.GetTrade(shopid, true);

            string json = PageUtils.TranformJSON(list);

            responder.WriteSuccessed(json);
        }
    }
}
