using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.GETBOOKINGRECORDLIST, "当前登陆用户的预订记录")]
    public class GetBookingRecordListHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            int start = SJSRequest.GetInt("start", 0);
            int limit = SJSRequest.GetInt("limit", PageUtils.DefaultPageSize);
            if (start <= 0)
            {
                start = 0;
            }
            if (limit <= 0)
            {
                limit = PageUtils.DefaultPageSize;
            }

            int curPage = PageUtils.TranformCurrentPage(start, limit);

            int len = BookingtradeManager.GetBookingtradeCountByUid(PageUtils.AccountID);
            IList<Bookingtrade> list = BookingtradeManager.GetBookingtrade(PageUtils.AccountID, limit, curPage, (uint)0);

            string json = PageUtils.TranformJSON(list);

            responder.WritePagingList(len, json);
        }
    }
}
