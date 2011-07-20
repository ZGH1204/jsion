#define OpenExcelN

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using MSExcel = Microsoft.Office.Interop.Excel;



namespace ConsoleTest
{
    class Program
    {
        static void Main(string[] args)
        {
            MSExcel.Application excel = new MSExcel.Application();
            //Console.WriteLine(Environment.GetFolderPath(Environment.SpecialFolder.Desktop));
            //Console.WriteLine(Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory));
            //excel.DisplayAlerts = false;
            //Console.WriteLine(excel.DefaultFilePath);
            if (excel.DefaultFilePath != Environment.GetFolderPath(Environment.SpecialFolder.Desktop))
            {
                excel.DefaultFilePath = Environment.GetFolderPath(Environment.SpecialFolder.Desktop);//"C:\\Users\\Jsion\\Documents"; //"C:\\Users\\Jsion\\Desktop";
                excel = new MSExcel.Application();
            }
            #if OpenExcel
            MSExcel.Workbook wbook = excel.Workbooks.Open("d:\\MyTest.xlsx");
            #else
            //excel.Workbooks.Application.DefaultFilePath = "C:\\Users\\Jsion\\Documents
            MSExcel.Workbook wbook = excel.Workbooks.Add(true);
            #endif

            MSExcel.Worksheet ws = (MSExcel.Worksheet)wbook.Sheets[1];
            ws.Name = "工作表1";
            ws.Select();

            MSExcel.Range r = ws.get_Range("A1", "A1");
            r.Value2 = 5;
            r.HorizontalAlignment = MSExcel.XlHAlign.xlHAlignCenter;
            r.EntireColumn.AutoFit();
            r.RowHeight = 50;
            r = ws.get_Range("B1", "B1");
            r.Value2 = 6;
            r.Select();
            excel.ActiveWindow.FreezePanes = true;
            r = ws.get_Range("C1", "C1");
            r.Value2 = 7;
            r = ws.get_Range("C3", "E6");
            r.Merge(r.MergeCells);
            //r.Borders.LineStyle = 1;
            //r.Borders.get_Item(MSExcel.XlBordersIndex.xlEdgeTop).LineStyle = MSExcel.XlLineStyle.xlContinuous;
            //r = ws.get_Range("D1", "D1");
            r = ws.get_Range("C3", "C3");
            r.Formula = "=SUM(A1:C1)";
            try
            {
                wbook.SaveAs("MyTest.xlsx", Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, MSExcel.XlSaveAsAccessMode.xlExclusive);
            }
            catch (Exception ex)
            {
                if (ex.Message.EndsWith("HRESULT:0x800A03EC")) Console.WriteLine("用户拒绝覆盖!");
                else Console.WriteLine(ex.Message);
            }
            //wbook.Save();
            wbook.Close(false);
            excel.Quit();
            Console.ReadLine();
        }
    }
}
