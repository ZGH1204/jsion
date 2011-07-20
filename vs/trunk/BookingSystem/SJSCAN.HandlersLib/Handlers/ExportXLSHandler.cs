using System;
using System.IO;
using System.Collections.Generic;
using System.Text;
using SJSCAN.HandlersLib.Interfaces;

using MSExcel = Microsoft.Office.Interop.Excel;
using System.Threading;
using Sjs.Common;
using SJSCAN.BLL;
using SJSCAN.Entity;

namespace SJSCAN.HandlersLib.Handlers
{
    [AjaxHandler(eHandlerTypes.EXPORTXLS, "导出Excel 2010")]
    public class ExportXLSHandler : IAjaxHandler
    {
        public void handler(IResponder responder)
        {
            string dir = System.Web.HttpContext.Current.Server.MapPath(".\\Excels");

            int bookingId = SJSRequest.GetInt("Bookingid", 0);

            if (bookingId <= 0)
            {
                responder.WriteSuccessedMsg("");
                return;
            }

            if (!Directory.Exists(dir))
            {
                Directory.CreateDirectory(dir);
            }

            MSExcel.Application excel = new MSExcel.Application();

            MSExcel.Workbook wbook = excel.Workbooks.Add(true);

            MSExcel.Worksheet ws = (MSExcel.Worksheet)wbook.Sheets[1];
            ws.Name = "预订报表";
            ws.Select();

            int offsetRow = 1;
            int offsetCol = 1;


            MSExcel.Range r = ws.get_Range(getCell(2 + offsetRow, 1 + offsetCol), Type.Missing);
            r.Select();
            excel.ActiveWindow.FreezePanes = true;


            r = ws.get_Range(getCell(1, 1), getCell(1, 7));
            r.Merge(r.MergeCells);
            r.HorizontalAlignment = MSExcel.XlHAlign.xlHAlignCenter;
            r.VerticalAlignment = MSExcel.XlVAlign.xlVAlignCenter;
            r.RowHeight = 25;
            r.Font.Bold = true;
            r.Font.Size = 14;
            r.Value2 = "预订报表";


            r = ws.get_Range(getCell(1 + offsetRow, 1 + offsetCol), Type.Missing);
            r.HorizontalAlignment = MSExcel.XlHAlign.xlHAlignCenter;
            r.VerticalAlignment = MSExcel.XlVAlign.xlVAlignCenter;
            r.ColumnWidth = 12;
            r.RowHeight = 25;
            r.Font.Bold = true;
            r.Value2 = "餐饮店";

            r = ws.get_Range(getCell(1 + offsetRow, 2 + offsetCol), Type.Missing);
            r.HorizontalAlignment = MSExcel.XlHAlign.xlHAlignCenter;
            r.VerticalAlignment = MSExcel.XlVAlign.xlVAlignCenter;
            r.ColumnWidth = 26;
            r.Font.Bold = true;
            r.Value2 = "菜单项";

            r = ws.get_Range(getCell(1 + offsetRow, 3 + offsetCol), Type.Missing);
            r.HorizontalAlignment = MSExcel.XlHAlign.xlHAlignCenter;
            r.VerticalAlignment = MSExcel.XlVAlign.xlVAlignCenter;
            r.ColumnWidth = 10;
            r.Font.Bold = true;
            r.Value2 = "数　量";

            r = ws.get_Range(getCell(1 + offsetRow, 4 + offsetCol), Type.Missing);
            r.HorizontalAlignment = MSExcel.XlHAlign.xlHAlignCenter;
            r.VerticalAlignment = MSExcel.XlVAlign.xlVAlignCenter;
            r.ColumnWidth = 10;
            r.Font.Bold = true;
            r.Value2 = "预订者";

            r = ws.get_Range(getCell(1 + offsetRow, 5 + offsetCol), Type.Missing);
            r.HorizontalAlignment = MSExcel.XlHAlign.xlHAlignCenter;
            r.VerticalAlignment = MSExcel.XlVAlign.xlVAlignCenter;
            r.ColumnWidth = 10;
            r.Font.Bold = true;
            r.Value2 = "签名";

            Dictionary<string, IList<Bookingtrade>> dic = new Dictionary<string, IList<Bookingtrade>>();



            IList<Bookingshop> list = BookingshopManager.GetBookingshop(bookingId, true);

            foreach (Bookingshop bs in list)
            {
                IList<Bookingtrade> tList = BookingtradeManager.GetBookingtrade(bs.Id, 0, 0);
                dic[bs.Shopname.Trim()] = tList;
            }

            string[] keys = new string[dic.Keys.Count];

            dic.Keys.CopyTo(keys, 0);

            int curRow = 2 + offsetRow;

            int startRow = 0;

            double allMoney = 0;

            Booking booking = BookingManager.GetBooking(bookingId);
            if(booking == null)
            {
                responder.WriteSuccessedMsg("");
                return;
            }
            DateTime dt = booking.Bookingtime;

            for (int i = 0; i < keys.Length; i++)
            {
                IList<Bookingtrade> tList = dic[keys[i]];
                startRow = curRow;
                allMoney = 0;
                for (int j = 0; j < tList.Count; j++, curRow++)
                {
                    //r = ws.get_Range(getCell(curRow, 1 + offsetCol), Type.Missing);
                    //r.Value2 = tList[j].Shopname.Trim();

                    r = ws.get_Range(getCell(curRow, 2 + offsetCol), Type.Missing);
                    r.RowHeight = 18;
                    r.Value2 = tList[j].Tradename.Trim();

                    r = ws.get_Range(getCell(curRow, 3 + offsetCol), Type.Missing);
                    r.HorizontalAlignment = MSExcel.XlHAlign.xlHAlignCenter;
                    r.Value2 = tList[j].Tradecount;

                    r = ws.get_Range(getCell(curRow, 4 + offsetCol), Type.Missing);
                    r.Value2 = tList[j].Realname.Trim();

                    allMoney = allMoney + tList[j].Tradevalue * tList[j].Tradecount;
                }

                r = ws.get_Range(getCell(startRow, 1 + offsetCol), getCell(curRow - 1, 1 + offsetCol));
                r.Merge(r.MergeCells);
                r.HorizontalAlignment = MSExcel.XlHAlign.xlHAlignCenter;
                r.VerticalAlignment = MSExcel.XlVAlign.xlVAlignCenter;
                r.Value2 = keys[i];

                r = ws.get_Range(getCell(curRow, 1 + offsetCol), Type.Missing);
                r.HorizontalAlignment = MSExcel.XlHAlign.xlHAlignRight;
                r.Font.Bold = true;
                r.RowHeight = 18;
                r.Value2 = "总数量：";

                r = ws.get_Range(getCell(curRow, 2 + offsetCol), Type.Missing);
                r.HorizontalAlignment = MSExcel.XlHAlign.xlHAlignCenter;
                r.Font.Bold = true;
                r.Formula = "=SUM(" + getCell(startRow, 3 + offsetCol) + ":" + getCell(curRow - 1, 3 + offsetCol) + ")";

                r = ws.get_Range(getCell(curRow, 3 + offsetCol), Type.Missing);
                r.HorizontalAlignment = MSExcel.XlHAlign.xlHAlignRight;
                r.Font.Bold = true;
                r.Value2 = "总　价：";

                r = ws.get_Range(getCell(curRow, 4 + offsetCol), Type.Missing);
                r.HorizontalAlignment = MSExcel.XlHAlign.xlHAlignCenter;
                r.Font.Bold = true;
                r.Value2 = allMoney;


                curRow++;

                //r = ws.get_Range(getCell(curRow, 1 + offsetCol), getCell(curRow, 4 + offsetCol));
                //r.Merge(r.MergeCells);
                //r.Value2 = 
            }

            r = ws.get_Range(getCell(1 + offsetRow, 1 + offsetCol), getCell(curRow - 1, 5 + offsetCol));
            r.Borders.LineStyle = 1;
            //r.Borders.get_Item(MSExcel.XlBordersIndex.xlEdgeTop).LineStyle = MSExcel.XlLineStyle.xlContinuous;

            string str = getCell(1, 1);

            string filename = dt.ToString("yyyyMMdd") + "报表.xlsx";
            string file = Path.Combine(dir, filename);
            File.Delete(file);

            try
            {
                wbook.SaveAs(file, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, MSExcel.XlSaveAsAccessMode.xlExclusive);
            }
            catch (Exception ex)
            {
                //if (ex.Message.EndsWith("HRESULT:0x800A03EC")) Console.WriteLine("用户拒绝覆盖!");
                //else Console.WriteLine(ex.Message);
            }


            wbook.Close(false);
            excel.Quit();
            //Thread.Sleep(1000);
            responder.WriteSuccessedMsg("/Excels/" + filename);
            //System.Web.HttpContext.Current.Response.Redirect("/Excels/" + filename);

            //FileInfo fi = new FileInfo(file);
            //responder.RWExcelFile(fi);
        }

        private string getCell(int row, int col)
        {
            char ch = (char)(col + 65 - 1);

            return (ch.ToString() + row.ToString());
        }
    }
}
