using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using Newtonsoft.Json;
using System.Web;

namespace Sjs.Common
{
    public class PageUtils
    {
        #region 生成分页链接

        /// <summary>
        /// 获取分页连接,继承后可重写
        /// </summary>
        /// <param name="currentPage">当前页码</param>
        /// <param name="pageSize">每页显示的记录数</param>
        /// <param name="pageUrl">连接的URL,其中应包含一个page={0},以便格式化</param>
        /// <param name="recordCount">总记录数</param>
        /// <returns>用户显示页码连接的Html字符串</returns>
        protected static string GetPageLink(int currentPage, int pageSize, string pageUrl, int recordCount)
        {
            // 校正页码
            if (currentPage <= 0)
            {
                currentPage = 1;
            }
            // 校正每页显示的记录数
            if (pageSize <= 0)
            {
                pageSize = DefaultPageSize;
            }
            // 计算总页数
            int m_pagecount = recordCount / pageSize;
            m_pagecount = ((recordCount % pageSize) == 0 ? m_pagecount : (m_pagecount + 1));
            // 校正页码
            if (m_pagecount < currentPage)
            {
                currentPage = m_pagecount;
            }

            StringBuilder sb = new StringBuilder();

            sb.Append("<div class=\"");
            sb.Append(GetPageLinkCls());
            sb.Append("\">");

            // 上一页连接
            if (currentPage == 1)
            {
                sb.Append("<span class=\"disabled\"> < </span>");
            }
            else
            {
                sb.Append("<a href=\"");
                sb.Append(string.Format(pageUrl, (currentPage - 1).ToString()));
                sb.Append("\"> < </a>");
            }
            // 页码连接
            if (m_pagecount > 10)
            {
                if (currentPage <= 4)
                {
                    for (int i = 1; i <= 7; i++)
                    {
                        if (i == currentPage)
                        {
                            sb.Append("<span class=\"current\">" + i.ToString() + "</span>");
                        }
                        else
                        {
                            sb.Append("<a href=\"" + string.Format(pageUrl, i.ToString()) + "\">" + i.ToString() + "</a>");
                        }
                    }
                }
                else
                {
                    sb.Append("<a href=\"" + string.Format(pageUrl, (currentPage - 3).ToString()) + "\">" + (currentPage - 3).ToString() + "</a>");
                    sb.Append("<a href=\"" + string.Format(pageUrl, (currentPage - 2).ToString()) + "\">" + (currentPage - 2).ToString() + "</a>");
                    sb.Append("<a href=\"" + string.Format(pageUrl, (currentPage - 1).ToString()) + "\">" + (currentPage - 1).ToString() + "</a>");
                    sb.Append("<a href=\"" + string.Format(pageUrl, currentPage.ToString()) + "\">" + currentPage.ToString() + "</a>");
                    sb.Append("<a href=\"" + string.Format(pageUrl, (currentPage + 1).ToString()) + "\">" + (currentPage - 1).ToString() + "</a>");
                    sb.Append("<a href=\"" + string.Format(pageUrl, (currentPage + 2).ToString()) + "\">" + (currentPage - 2).ToString() + "</a>");
                    sb.Append("<a href=\"" + string.Format(pageUrl, (currentPage + 3).ToString()) + "\">" + (currentPage - 3).ToString() + "</a>");

                    if ((m_pagecount - currentPage) > 5)
                    {
                        sb.Append("…");
                        sb.Append("<a href=\"" + string.Format(pageUrl, (m_pagecount - 1).ToString()) + "\">" + (currentPage - 3).ToString() + "</a>");
                        sb.Append("<a href=\"" + string.Format(pageUrl, m_pagecount.ToString()) + "\">" + (currentPage - 3).ToString() + "</a>");
                    }
                    else
                    {
                        for (int i = currentPage + 4; i <= m_pagecount; i++)
                        {
                            sb.Append("<a href=\"" + string.Format(pageUrl, i.ToString()) + "\">" + i.ToString() + "</a>");
                        }
                    }
                }
            }
            else
            {
                // 总页数不大于10时,全部显示
                for (int i = 1; i <= m_pagecount; i++)
                {
                    if (i == currentPage)
                    {
                        sb.Append("<span class=\"current\">" + i.ToString() + "</span>");
                    }
                    else
                    {
                        sb.Append("<a href=\"" + string.Format(pageUrl, i.ToString()) + "\">" + i.ToString() + "</a>");
                    }
                }
            }
            // 下一页连接
            if (currentPage == m_pagecount)
            {
                // 当前已是最后一页
                sb.Append("<span class=\"disabled\">Next &gt;</span>");
            }
            else
            {
                // 当前不是最后一页
                sb.Append("<a href=\"");
                sb.Append(string.Format(pageUrl, (currentPage + 1).ToString()));
                sb.Append("\"> > </a>");
            }

            sb.Append("</div>");

            return sb.ToString();
        }

        /// <summary>
        /// 分页连接的样式
        /// </summary>
        public static PageLinkStyle PageLinkCls
        {
            get { return PageLinkStyle.FlickrStyle; }
        }

        /// <summary>
        /// 获取分页连接样式类名
        /// </summary>
        /// <returns></returns>
        protected static string GetPageLinkCls()
        {
            string str = "";
            switch (PageLinkCls)
            {
                case PageLinkStyle.DiggStyle:
                    str = "digg";
                    break;
                case PageLinkStyle.YahooStyle:
                    str = "yahoo";
                    break;
                case PageLinkStyle.Yahoo2Style:
                    str = "yahoo2";
                    break;
                case PageLinkStyle.MeneameStyle:
                    str = "meneame";
                    break;
                case PageLinkStyle.FlickrStyle:
                    str = "flickr";
                    break;
                case PageLinkStyle.SabrosusStyle:
                    str = "sabrosus";
                    break;
                case PageLinkStyle.ScottStyle:
                    str = "scott";
                    break;
                case PageLinkStyle.QuotesStyle:
                    str = "quotes";
                    break;
                case PageLinkStyle.BlackStyle:
                    str = "black";
                    break;
                case PageLinkStyle.Black2Style:
                    str = "black2";
                    break;
                case PageLinkStyle.Black_RedStyle:
                    str = "black-red";
                    break;
                case PageLinkStyle.GrayrStyle:
                    str = "grayr";
                    break;
                case PageLinkStyle.YellowStyle:
                    str = "yellow";
                    break;
                case PageLinkStyle.JoggerStyle:
                    str = "jogger";
                    break;
                case PageLinkStyle.Starcraft2Style:
                    str = "starcraft2";
                    break;
                case PageLinkStyle.TresStyle:
                    str = "tres";
                    break;
                case PageLinkStyle.Megas512Style:
                    str = "megas512";
                    break;
                case PageLinkStyle.TechnoratiStyle:
                    str = "technorati";
                    break;
                case PageLinkStyle.YouTubeStyle:
                    str = "youtube";
                    break;
                case PageLinkStyle.MSDNStyle:
                    str = "msdn";
                    break;
                case PageLinkStyle.BadooStyle:
                    str = "badoo";
                    break;
                case PageLinkStyle.ManuStyle:
                    str = "manu";
                    break;
                case PageLinkStyle.Green_BlackStyle:
                    str = "green-black";
                    break;
                case PageLinkStyle.ViciaoStyle:
                    str = "viciao";
                    break;
                default:
                    str = "flickr";
                    break;
            }

            return str;
        }

        /// <summary>
        /// 连接分页样式枚举类
        /// </summary>
        public enum PageLinkStyle
        {
            DiggStyle,
            YahooStyle,
            Yahoo2Style,
            MeneameStyle,
            FlickrStyle,
            SabrosusStyle,
            ScottStyle,
            QuotesStyle,
            BlackStyle,
            Black2Style,
            Black_RedStyle,
            GrayrStyle,
            YellowStyle,
            JoggerStyle,
            Starcraft2Style,
            TresStyle,
            Megas512Style,
            TechnoratiStyle,
            YouTubeStyle,
            MSDNStyle,
            BadooStyle,
            ManuStyle,
            Green_BlackStyle,
            ViciaoStyle
        }

        #endregion

        #region Session相关

        public static bool IsLogined
        {
            get { return (AccountID > 0); }
        }

        protected static string AccountSession
        {
            get { return "Account"; }
        }

        public static string Account
        {
            get
            {
                if (HttpContext.Current.Session == null || HttpContext.Current.Session[AccountSession] == null || string.IsNullOrEmpty(HttpContext.Current.Session[AccountSession].ToString()))
                {
                    return "";
                }

                return HttpContext.Current.Session[AccountSession].ToString();
            }
            set
            {
                HttpContext.Current.Session[AccountSession] = value;
            }
        }

        protected static string AccountIDSession
        {
            get { return "AccountID"; }
        }

        public static int AccountID
        {
            get
            {
                if (HttpContext.Current.Session == null || HttpContext.Current.Session[AccountIDSession] == null || string.IsNullOrEmpty(HttpContext.Current.Session[AccountIDSession].ToString()))
                {
                    HttpContext.Current.Session[AccountIDSession] = 0;
                }

                return int.Parse(HttpContext.Current.Session[AccountIDSession].ToString());
            }
            set
            {
                HttpContext.Current.Session[AccountIDSession] = value;
            }
        }

        protected static string RealNameSession
        {
            get { return "RealName"; }
        }

        public static string RealName
        {
            get
            {
                if (HttpContext.Current.Session == null || HttpContext.Current.Session[RealNameSession] == null || string.IsNullOrEmpty(HttpContext.Current.Session[RealNameSession].ToString()))
                {
                    return "";
                }

                return HttpContext.Current.Session[RealNameSession].ToString();
            }
            set
            {
                HttpContext.Current.Session[RealNameSession] = value;
            }
        }

        public static int Utype
        {
            get
            {
                if (HttpContext.Current.Session == null || HttpContext.Current.Session["utype"] == null || string.IsNullOrEmpty(HttpContext.Current.Session["utype"].ToString()))
                {
                    HttpContext.Current.Session["utype"] = 0;
                }

                return int.Parse(HttpContext.Current.Session["utype"].ToString());
            }
            set
            {
                HttpContext.Current.Session["utype"] = value;
            }
        }

        #endregion

        public const int DefaultPageSize = 30;

        public static string ExtSuccess(string json)
        {
            return "{success:true,data:" + json + "}";
        }

        public static string ExtPagingList(int len, string json)
        {
            return "{success:true,totalCount:" + len.ToString() + ",data:" + json + "}";
        }

        public static string ExtError(string json)
        {
            return "{success:false,errors:" + json + "}";
        }

        public static int TranformCurrentPage(int startIndex, int pageSize)
        {
            int page = startIndex / pageSize;
            return ++page;
        }

        public static string TranformJSON(Object value)
        {
            StringBuilder sb = new StringBuilder();
            StringWriter sw = new StringWriter(sb);
            JsonSerializer serializer = new JsonSerializer();

            using (JsonWriter jw = new JsonWriter(sw))
            {
                serializer.Serialize(jw, value);
            }

            return sb.ToString();
        }
    }
}
