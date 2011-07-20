using System;
using System.Collections.Generic;
using System.Web;
using WebAppLib;
using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.HandlersLib.Interfaces;
using System.IO;

namespace WebApplication
{
    public class WebPage : PageBase, IResponder
    {
        public override bool UnloginedJumpEnable
        {
            get
            {
                return false;
            }
        }


        public void WritePagingList(int len, string str)
        {
            RWE(PageUtils.ExtPagingList(len, str));
        }

        public void WriteSuccessed(string str)
        {
            RWE(PageUtils.ExtSuccess(str));
        }

        public void WriteSuccessed(HttpContext context, string str)
        {
            RWE(context, PageUtils.ExtSuccess(str));
        }

        public void WriteErrored(string str)
        {
            RWE(PageUtils.ExtError(str));
        }

        public void WriteErrored(HttpContext context, string str)
        {
            RWE(context, PageUtils.ExtError(str));
        }


        public void WriteSuccessedMsg(string str)
        {
            WriteSuccessed("{msg: '" + str + "'}");
        }

        public void WriteSuccessedMsg(HttpContext context, string str)
        {
            WriteSuccessed(context, "{msg: '" + str + "'}");
        }

        public void WriteErroredMsg(string str)
        {
            WriteErrored("{msg: '" + str + "'}");
        }

        public void WriteErroredMsg(HttpContext context, string str)
        {
            WriteErrored(context, "{msg: '" + str + "'}");
        }

        public void RWExcelFile(FileInfo file)
        {
            base.RWExcel(file);
        }

        protected void Logined(User user)
        {
            AccountID = user.Uid;
            Account = user.Account;
            RealName = user.Realname;
            Utype = user.Type;
        }



        public virtual int Utype
        {
            get
            {
                return PageUtils.Utype;
            }
            set
            {
                PageUtils.Utype = value;
            }
        }
    }
}