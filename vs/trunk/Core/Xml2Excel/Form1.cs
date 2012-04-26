using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Xml;
using Xml2Excel.Core;
using MSExcel = Microsoft.Office.Interop.Excel;
using System.IO;

namespace Xml2Excel
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();

            int i;

            i = GetBitCount(25);

            i = GetBitCount(26);

            i = GetBitCount(27);

            i = GetBitCount(51);

            i = GetBitCount(52);

            i = GetBitCount(53);

            i = GetBitCount(675);

            i = GetBitCount(676);

            i = GetBitCount(677);
        }

        private int GetBitCount(int n)
        {
            int max = 1;
            while (n > Math.Pow(26, max))
            {
                max++;
            }

            return max;
        }

        private void Form1_DragEnter(object sender, DragEventArgs e)
        {
            if (e.Data.GetDataPresent(DataFormats.FileDrop))
                e.Effect = DragDropEffects.Link;
            else e.Effect = DragDropEffects.None;
        }

        private void Form1_DragDrop(object sender, DragEventArgs e)
        {
            string fileName = ((System.Array)e.Data.GetData(DataFormats.FileDrop)).GetValue(0).ToString();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            OpenFileDialog ofd = new OpenFileDialog();

            ofd.Title = "选择文件";
            ofd.Filter = "xml files (*.xml)|*.xml";
            ofd.FilterIndex = 1;

            if (ofd.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                string str = ofd.FileName;

                XmlDocument doc = new XmlDocument();

                doc.Load(str);

                XmlNode root = doc.DocumentElement;

                List<TemplateStruct> list = new List<TemplateStruct>();

                foreach (XmlNode node in root.ChildNodes)
                {
                    if (node.ChildNodes.Count != 0)
                    {
                        XmlNode item = node.ChildNodes[0];

                        if (item.NodeType != XmlNodeType.Element) continue;

                        TemplateStruct t = new TemplateStruct();

                        t.NodeName = item.LocalName;
                        t.Attributes = new List<string>();

                        foreach (XmlAttribute att in item.Attributes)
                        {
                            t.Attributes.Add(att.LocalName);
                        }

                        list.Add(t);
                    }
                }



                MSExcel.Application excel = new MSExcel.Application();

                MSExcel.Workbook wbook = excel.Workbooks.Add(true);

                for (int i = 0; i < list.Count; i++)
                {
                    if (i > 0) wbook.Sheets.Add(Type.Missing, wbook.Sheets[i], 1, Type.Missing);

                    MSExcel.Worksheet ws = (MSExcel.Worksheet)wbook.Sheets[i + 1];

                    ws.Select();

                    TemplateStruct ts = list[i];

                    ws.Name = ts.NodeName;

                    MSExcel.Range r = ws.get_Range(getCell(2, 1), Type.Missing);
                    r.Select();
                    excel.ActiveWindow.FreezePanes = true;

                    for (int j = 0; j < ts.Attributes.Count; j++)
                    {
                        r = ws.get_Range(getCell(1, j + 1));
                        r.ColumnWidth = 15;
                        r.Value2 = ts.Attributes[j];
                    }
                }

                File.Delete("C:\\Users\\Jsion\\Desktop\\test.xlsx");

                wbook.SaveAs("C:\\Users\\Jsion\\Desktop\\test.xlsx", Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, MSExcel.XlSaveAsAccessMode.xlExclusive);

                wbook.Close(false);

                excel.Quit();
            }
        }

        private static string[] zimu = new string[] { "", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" };

        private string GetStr(int num)
        {
            if (num <= 0) return "";

            int one = (int)(num / 26);
            int two = num % 26;
            int t = 0;

            if (two == 0)
            {
                one = Math.Max(0, one - 1);
                two = 26;
            }

            if (one > 26)
            {
                return GetStr(one) + zimu[two];
            }
            else
            {
                return zimu[one] + zimu[two];
            }
        }

        private string getCell(int row, int col)
        {
            string ch = GetStr(col);

            return (ch.ToString() + row.ToString());
        }
    }
}
