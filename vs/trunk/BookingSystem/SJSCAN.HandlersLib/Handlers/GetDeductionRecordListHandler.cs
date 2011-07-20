using System;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.GETDEDUCTIONRECORDLIST, "获取扣款记录")]
    public class GetDeductionRecordListHandler : IAjaxHandler
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

            int len = DeductionManager.GetDeductionCount(PageUtils.AccountID);
            IList<Deduction> list = DeductionManager.GetDeduction(PageUtils.AccountID, limit, curPage);

            string json = PageUtils.TranformJSON(list);

            responder.WritePagingList(len, json);
        }
    }
}
