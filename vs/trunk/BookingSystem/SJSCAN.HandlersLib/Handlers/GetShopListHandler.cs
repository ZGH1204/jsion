using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.GETSHOPLIST, "获取店铺列表")]
    public class GetShopListHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            IList<Shop> list = ShopManager.GetShop();

            string json = PageUtils.TranformJSON(list);

            responder.WriteSuccessed(json);
        }
    }
}
