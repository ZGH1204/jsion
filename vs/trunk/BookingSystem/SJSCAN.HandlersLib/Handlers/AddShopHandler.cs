using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.ADDSHOP, "新增店铺")]
    public class AddShopHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            Shop shop = new Shop();

            shop.Shopname = SJSRequest.GetString("Shopname");
            shop.Phone = SJSRequest.GetString("Phone");

            if (string.IsNullOrEmpty(shop.Shopname))
            {
                responder.WriteErroredMsg("店铺名称不能为空!");
                return;
            }

            int rlt = ShopManager.AddShop(shop);

            if (rlt <= 0)
            {
                responder.WriteErroredMsg("新增店铺失败,数据库写入不成功!");
                return;
            }

            responder.WriteSuccessedMsg("新增店铺成功!");
        }
    }
}
