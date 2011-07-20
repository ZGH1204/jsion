using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.EDITSHOP, "修改店铺")]
    public class EditShopHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            int id = SJSRequest.GetInt("Id", 0);

            if (id <= 0)
            {
                responder.WriteErroredMsg("请求参数错误!");
                return;
            }

            Shop shop = ShopManager.GetShop(id);

            if (shop == null)
            {
                responder.WriteErroredMsg("此店铺不存在,无法修改!");
                return;
            }

            int hasBookingCount = BookingshopManager.GetBookingshop(shop.Id, false, true);
            if (hasBookingCount > 0)
            {
                responder.WriteErroredMsg("此店铺正在接受预订,无法修改!");
                return;
            }

            shop.Shopname = SJSRequest.GetString("Shopname");
            shop.Phone = SJSRequest.GetString("Phone");

            if (string.IsNullOrEmpty(shop.Shopname))
            {
                responder.WriteErroredMsg("店铺名称不能为空!");
                return;
            }

            int rlt = ShopManager.UpdateShop(shop);

            if (rlt <= 0)
            {
                responder.WriteErroredMsg("店铺修改失败,数据库更新不成功!");
                return;
            }

            responder.WriteSuccessedMsg("修改店铺成功!");
        }
    }
}
