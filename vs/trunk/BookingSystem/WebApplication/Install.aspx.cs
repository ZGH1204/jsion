using System;
using System.Collections.Generic;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Sjs.Common;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace WebApplication
{
    public partial class Install : System.Web.UI.Page
    {
        protected bool IsInstall = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            IList<App> list = AppManager.GetApp();

            if (list.Count > 0)
            {
                IsInstall = list[0].Isinstall;
            }
        }
    }
}