using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using Sjs.Common;
using System.IO;

namespace WebAppLib
{
    public class PageBase : System.Web.UI.Page
    {
        protected StringBuilder templateBuilder = new StringBuilder();

        public PageBase()
        {
            if (UseShow)
            {
                ShowPage();
            }
            else
            {
                this.Load += new EventHandler(Page_Load);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            //throw new NotImplementedException();
            if (IsLogined == false && UnloginedJumpEnable)
            {
                Response.Redirect(LoginUrl, true);
                return;
            }
            PageLoaded();
        }

        protected virtual void PageLoaded()
        {
        }

        /// <summary>
        /// 跳过生命周期时执行的函数（可重写）
        /// </summary>
        protected virtual void ShowPage()
        {
            templateBuilder.Append("未重写实现具体操作");
        }
        
        /// <summary>
        /// 是否跳过生命周期在构造函数时直接执行（可重写）
        /// </summary>
        public virtual bool UseShow
        {
            get { return false; }
        }

        /// <summary>
        /// 未登陆或登陆超时是否允许跳转到登陆页面（可重写）
        /// </summary>
        public virtual bool UnloginedJumpEnable
        {
            get { return true; }
        }

        /// <summary>
        /// 登陆页面相对地址（可重写）
        /// </summary>
        public virtual string LoginUrl
        {
            get { return "/Account/Login.aspx"; }
        }

        public virtual int AccountID
        {
            get
            {
                return PageUtils.AccountID;
            }
            set
            {
                PageUtils.AccountID = value;
            }
        }

        public virtual string Account
        {
            get
            {
                return PageUtils.Account;
            }
            set
            {
                PageUtils.Account = value;
            }
        }

        public virtual string RealName
        {
            get
            {
                return PageUtils.RealName;
            }
            set
            {
                PageUtils.RealName = value;
            }
        }

        public virtual bool IsLogined
        {
            get { return PageUtils.IsLogined; }
        }

        /// <summary>
        /// 向客户端输出指定字符串,不结束输出
        /// </summary>
        /// <param name="str"></param>
        protected virtual void RW(string str)
        {
            HttpContext.Current.Response.Write(str);
        }

        /// <summary>
        /// 向客户端输出指定字符串,不结束输出
        /// </summary>
        /// <param name="str"></param>
        protected virtual void RW(HttpContext context, string str)
        {
            context.Response.Write(str);
        }

        /// <summary>
        /// 向客户端输出指定字符串,并结束输出
        /// </summary>
        /// <param name="str"></param>
        protected virtual void RWE(string str)
        {
            HttpContext.Current.Response.Write(str);
            HttpContext.Current.Response.End();
        }

        /// <summary>
        /// 向客户端输出指定字符串,并结束输出
        /// </summary>
        /// <param name="str"></param>
        protected virtual void RWE(HttpContext context, string str)
        {
            context.Response.Write(str);
            context.Response.End();
        }

        protected virtual void RWExcel(FileInfo file)
        {
            HttpContext.Current.Response.Clear();
            HttpContext.Current.Response.Charset = "GB2312";
            HttpContext.Current.Response.ContentEncoding = Encoding.UTF8;
            HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment; filename=" + Server.UrlEncode(file.Name)); 
            HttpContext.Current.Response.ContentType = "application/ms-excel";
            HttpContext.Current.Response.WriteFile(file.FullName);
            HttpContext.Current.Response.End();
        }
    }
}
