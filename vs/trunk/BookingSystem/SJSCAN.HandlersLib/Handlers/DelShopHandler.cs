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
    [AjaxHandler(eHandlerTypes.DELSHOP, "删除店铺")]
    public class DelShopHandler : IAjaxHandler
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
                responder.WriteErroredMsg("此店铺不存在,无法删除!");
                return;
            }

            int hasBookingCount = BookingshopManager.GetBookingshop(shop.Id, false, true);
            if (hasBookingCount > 0)
            {
                responder.WriteErroredMsg("此店铺正在接受预订,无法删除!");
                return;
            }

            using (DbTransaction trans = DbHelper.BeginTransaction())
            {
                bool writeError = false;
                try
                {
                    int rlt = ShopManager.DelShop(id, trans);

                    if (rlt <= 0)
                    {
                        writeError = true;
                        trans.Rollback();
                        responder.WriteErroredMsg("店铺删除失败,数据库更新不成功!");
                        return;
                    }

                    TradeManager.DelTrade(id, trans);

                    trans.Commit();
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    if (writeError == false) responder.WriteErroredMsg("店铺删除失败,程序异常!");
                    return;
                }
            }

            responder.WriteSuccessedMsg("店铺删除成功!");
        }
    }
}
