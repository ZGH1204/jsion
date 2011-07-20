using System;
using System.Data;
using System.Collections.Generic;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Sjs.Common;
using System.Xml;
using System.Data.Common;
using Sjs.Data;
using SJSCAN.Entity;
using SJSCAN.BLL;

namespace WebApplication
{
    public partial class ImportData : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string str = SJSRequest.GetString("import");
            if (str == "User")
            {
                importUser();
            }
            else if (str == "ShopAndTrade")
            {
                importShopAndTrade();
            }
            else if (str == "App")
            {
                importApp();
            }
            else
            {
                Response.Write("?import=[以下三个值之一]<br />");
                Response.Write("1.App : 设置初始化<br />");
                Response.Write("2.User : 导入用户数据(根目录下的User.xml文件内的数据)<br />");
                Response.Write("3.ShopAndTrade : 导入用户数据(根目录下的ShopAndTrade.xml文件内的数据)<br />");
            }
        }

        private void importApp()
        {
            IList<App> list = AppManager.GetApp();

            if (list.Count == 0)
            {
                App app = new App();
                app.Isinstall = true;
                app.Id = AppManager.AddApp(app);
                if (app.Id <= 0)
                {
                    Response.Write("<br />初始化设置失败.<br />");
                    return;
                }
            }
            else
            {
                list[0].Isinstall = true;
                if (AppManager.UpdateApp(list[0]) <= 0)
                {
                    Response.Write("<br />初始化设置失败.<br />");
                    return;
                }
            }

            Response.Write("<br />初始化设置成功.<br />");
        }

        private void importUser()
        {
            XMLHelper xh = new XMLHelper(Server.MapPath("/User.xml"));

            XmlNodeList xnl = xh.GetXmlNode("users").ChildNodes;

            using (DbTransaction trans = DbHelper.BeginTransaction())
            {
                try
                {
                    foreach (XmlNode xn in xnl)
                    {
                        User user = new User();

                        user.Account = xn.Attributes["Account"].InnerText;
                        user.Passwd = xn.Attributes["Passwd"].InnerText;
                        user.Realname = xn.Attributes["Realname"].InnerText;
                        user.Balance = Convert.ToDouble(xn.Attributes["Balance"].InnerText);
                        user.Type = Convert.ToInt32(xn.Attributes["Type"].InnerText);

                        user.Uid = UserManager.AddUser(user, trans);

                        if (user.Uid <= 0)
                        {
                            trans.Rollback();
                            Response.Write("<br />事务出错执行回滚.<br />");
                            return;
                        }
                    }

                    trans.Commit();
                    Response.Write("<br />用户列表导入成功.<br />");
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    Response.Write("<br />事务出错执行回滚.<br />");
                }
            }
        }

        private void importShopAndTrade()
        {
            XMLHelper xh = new XMLHelper(Server.MapPath("/ShopAndTrade.xml"));

            XmlNodeList xnl = xh.GetXmlNode("shops").ChildNodes;

            using (DbTransaction trans = DbHelper.BeginTransaction())
            {
                try
                {
                    foreach (XmlNode xn in xnl)
                    {
                        Shop shop = new Shop();

                        shop.Shopname = xn.Attributes["Shopname"].InnerText;
                        shop.Phone = xn.Attributes["Phone"].InnerText;

                        shop.Id = ShopManager.AddShop(shop, trans);

                        if (shop.Id <= 0)
                        {
                            trans.Rollback();
                            Response.Write("<br />事务出错执行回滚.<br />");
                            return;
                        }

                        foreach (XmlNode tradeXN in xn.ChildNodes)
                        {
                            Trade trade = new Trade();

                            trade.Shopid = shop.Id;

                            trade.Tradename = tradeXN.Attributes["Tradename"].InnerText;
                            trade.Tradevalue = Convert.ToDouble(tradeXN.Attributes["Tradevalue"].InnerText);

                            trade.Id = TradeManager.AddTrade(trade, trans);

                            if (trade.Id <= 0)
                            {
                                trans.Rollback();
                                Response.Write("<br />事务出错执行回滚.<br />");
                                return;
                            }
                        }

                        //Response.Write(xn.Attributes["Shopname"].InnerText + "<br />");
                    }



                    trans.Commit();
                    Response.Write("<br />店铺和菜单导入.<br />");
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    Response.Write("<br />事务出错执行回滚.<br />");
                }
            }
        }
    }
}