using System;
using System.Collections.Generic;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Sjs.Common;
using SJSCAN.HandlersLib.Interfaces;
using SJSCAN.HandlersLib;

namespace WebApplication
{
    public partial class Ajax1 : WebPage
    {
        protected override void PageLoaded()
        {
            string method = SJSRequest.GetString("Method");

            if (string.IsNullOrEmpty(method))
            {
                WriteErroredMsg("请求出错,方法名不能为空!");
                return;
            }

            if (method != eHandlerTypes.GETUSERINFO && method != eHandlerTypes.GETCURRENTBOOKINGEDLIST && method != eHandlerTypes.INSTALLSYS)
            {
                if (PageUtils.IsLogined == false && method != eHandlerTypes.LOGIN)
                {
                    WriteErroredMsg("未登陆或登陆超时,请重新登陆!");
                    return;
                }
                else if (PageUtils.IsLogined && method == eHandlerTypes.LOGIN)
                {
                    WriteErroredMsg("已经登陆过,请不要重复登陆!");
                    return;
                }
            }


            IAjaxHandler handler = AjaxHandlerMgr.Instance.loadHandler(method);

            if (handler == null)
            {
                WriteErroredMsg("找不到对应的Handler!");
                return;
            }

            handler.handler(this);

            //try
            //{
            //    handler.handler(this);
            //}
            //catch (Exception ex)
            //{
            //    //Response.Clear();
            //    //WriteErroredMsg(string.Format("处理方法{0}时出错,{1}", method, ex.Message));
            //}
        }
    }
}