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
        private const int ExcelMaxRow = 1048576;
        private const int ExcelMaxCol = 16384;
        private const int StructRow = 2;
        private const int StructCol = 1;
        private const int FreezeRow = 3;
        private const int FreezeCol = 2;
        private const int ExcelDataStart = 3;

        private static string[] zimu = new string[] { "", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" };

        public Form1()
        {
            InitializeComponent();
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
            ofd.Filter = "Xml files (*.xml)|*.xml";
            ofd.FilterIndex = 1;

            if (ofd.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                string str = ofd.FileName;

                XmlDocument doc = new XmlDocument();

                doc.Load(str);

                XmlNode root = doc.DocumentElement;

                List<TemplateStruct> list = GetTemplateStructList(root);
                Dictionary<string, List<TemplateValue>> dic = GetTemplateList(root);

                MSExcel.Application excel = new MSExcel.Application();

                MSExcel.Workbook wbook = excel.Workbooks.Add(true);

                CreateExcelStruct(list, excel, wbook);

                UpdateExcelData(list, dic, wbook);

                string path = str.Substring(0, str.LastIndexOf("\\"));
                string filename = str.Substring(str.LastIndexOf("\\") + 1).Replace(".xml","") + ".xlsx";
                path = Path.Combine(path, filename);

                SaveExcel(path, excel, wbook);

                MessageBox.Show("转换成功");
            }
        }

        private void UpdateExcelData(List<TemplateStruct> list, Dictionary<string, List<TemplateValue>> dic, MSExcel.Workbook wbook)
        {
            for (int i = 0; i < list.Count; i++)
            {
                TemplateStruct ts = list[i];

                List<TemplateValue> temp = dic[list[i].NodeName];

                int start = ExcelDataStart;

                MSExcel.Worksheet ws = (MSExcel.Worksheet)wbook.Sheets[i + 1];

                for (int j = 0; j < temp.Count; j++)
                {
                    TemplateValue tv = temp[j];

                    for (int k = 0; k < ts.Attributes.Count; k++)
                    {
                        MSExcel.Range r = ws.get_Range(getCell(start, k + StructCol));
                        r.Value2 = tv.Props[ts.Attributes[k]];
                    }

                    start++;
                }
            }
        }

        private List<TemplateStruct> GetTemplateStructList(XmlNode root)
        {
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

            return list;
        }

        private Dictionary<string, List<TemplateValue>> GetTemplateList(XmlNode root)
        {
            Dictionary<string, List<TemplateValue>> dic = new Dictionary<string, List<TemplateValue>>();

            foreach (XmlNode node in root.ChildNodes)
            {
                foreach (XmlNode item in node.ChildNodes)
                {
                    if (item.NodeType != XmlNodeType.Element) continue;

                    if (!dic.ContainsKey(item.LocalName))
                    {
                        dic[item.LocalName] = new List<TemplateValue>();
                    }

                    TemplateValue tv = new TemplateValue();
                    dic[item.LocalName].Add(tv);
                    tv.NodeName = item.LocalName;
                    tv.Props = new Dictionary<string, string>();

                    foreach (XmlAttribute att in item.Attributes)
                    {
                        tv.Props[att.LocalName] = att.Value;
                    }
                }
            }

            return dic;
        }

        private void CreateExcelStruct(List<TemplateStruct> list, MSExcel.Application excel, MSExcel.Workbook wbook)
        {
            for (int i = 0; i < list.Count; i++)
            {
                if (i > 0) wbook.Sheets.Add(Type.Missing, wbook.Sheets[i], 1, Type.Missing);

                MSExcel.Worksheet ws = (MSExcel.Worksheet)wbook.Sheets[i + 1];

                ws.Select();

                TemplateStruct ts = list[i];

                ws.Name = ts.NodeName;

                MSExcel.Range r = ws.get_Range(getCell(FreezeRow, FreezeCol), Type.Missing);
                r.Select();
                excel.ActiveWindow.FreezePanes = true;

                for (int j = 0; j < ts.Attributes.Count; j++)
                {
                    r = ws.get_Range(getCell(StructRow, j + StructCol));
                    r.ColumnWidth = 15;
                    
                    r.Value2 = ts.Attributes[j];
                }
            }
        }

        private void SaveExcel(string file, MSExcel.Application excel, MSExcel.Workbook wbook)
        {
            try
            {
                File.Delete(file);
            }
            catch //(Exception ex)
            {
                wbook.Close(false);

                excel.Quit();

                return;
            }

            try
            {
                wbook.SaveAs(file, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, MSExcel.XlSaveAsAccessMode.xlExclusive);
            }
            catch//(Exception ex)
            {

            }

            wbook.Close(false);

            excel.Quit();
        }

        private string GetStr(int num)
        {
            if (num <= 0) return "";

            int one = (int)(num / 26);
            int two = num % 26;

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







        private void button2_Click(object sender, EventArgs e)
        {
             OpenFileDialog ofd = new OpenFileDialog();

            ofd.Title = "选择文件";
            ofd.Filter = "Xml files (*.xlsx)|*.xlsx";
            ofd.FilterIndex = 1;

            List<string> temp, temp2;
            Dictionary<string, TemplateStruct> list;
            Dictionary<string, List<TemplateValue>> dic;

            if (ofd.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                string str = ofd.FileName;

                MSExcel.Application excel = new MSExcel.Application();

                MSExcel.Workbook wbook = excel.Workbooks.Open(str);

                list = GetExcelStructList(wbook);
                dic = GetExcelList(wbook, list);

                temp = list.Keys.ToList();

                XmlDocument doc = new XmlDocument();
                doc.LoadXml("<root></root>");
                XmlNode root = doc.DocumentElement;

                for (int i = 0; i < temp.Count; i++)
                {
                    TemplateStruct ts = list[temp[i]];
                    List<TemplateValue> tvList = dic[ts.NodeName];

                    XmlNode node = doc.CreateNode(XmlNodeType.Element, "ArrayOf" + ts.NodeName, "");

                    root.AppendChild(node);

                    for (int j = 0; j < tvList.Count; j++)
                    {
                        TemplateValue tv = tvList[j];
                        temp2 = tv.Props.Keys.ToList();

                        XmlNode item = doc.CreateNode(XmlNodeType.Element, tv.NodeName, "");
                        node.AppendChild(item);

                        for (int k = 0; k < temp2.Count; k++)
                        {
                            XmlAttribute xa = doc.CreateAttribute(temp2[k]);
                            xa.Value = tv.Props[temp2[k]];
                            item.Attributes.Append(xa);
                        }
                    }
                }

                wbook.Close(false);

                excel.Quit();


                string path = str.Substring(0, str.LastIndexOf("\\"));
                string filename = str.Substring(str.LastIndexOf("\\") + 1).Replace(".xlsx", "") + ".xml";
                path = Path.Combine(path, filename);


                try
                {
                    File.Delete(path);

                    doc.Save(path);

                    MessageBox.Show("转换成功");
                }
                catch //(Exception ex)
                {
                    MessageBox.Show("转换失败");
                    return;
                }
            }
        }

        private Dictionary<string, TemplateStruct> GetExcelStructList(MSExcel.Workbook wbook)
        {
            Dictionary<string, TemplateStruct> list = new Dictionary<string, TemplateStruct>();

            int count = wbook.Worksheets.Count;

            for (int i = 0; i < count; i++)
            {
                MSExcel.Worksheet sheet = wbook.Worksheets[i + 1];

                TemplateStruct ts = new TemplateStruct();

                ts.NodeName = sheet.Name;
                ts.Attributes = new List<string>();

                list[ts.NodeName] = ts;

                for (int j = 0; j < ExcelMaxCol; j++)
                {
                    MSExcel.Range r = sheet.get_Range(getCell(StructRow, j + StructCol));

                    if (string.IsNullOrEmpty(r.Value2))
                    {
                        break;
                    }

                    ts.Attributes.Add(r.Value2);
                }
            }

            return list;
        }

        private Dictionary<string, List<TemplateValue>> GetExcelList(MSExcel.Workbook wbook, Dictionary<string, TemplateStruct> list)
        {
            Dictionary<string, List<TemplateValue>> dic = new Dictionary<string, List<TemplateValue>>();

            int count = wbook.Worksheets.Count;

            for (int i = 0; i < count; i++)
            {
                MSExcel.Worksheet sheet = wbook.Worksheets[i + 1];
                TemplateStruct ts = list[sheet.Name];

                if (!dic.ContainsKey(ts.NodeName))
                {
                    dic[ts.NodeName] = new List<TemplateValue>();
                }

                int start = ExcelDataStart;
                bool endRow = false;

                for (int j = 0; j < ExcelMaxRow; j++)
                {
                    TemplateValue tv = new TemplateValue();
                    tv.NodeName = ts.NodeName;
                    tv.Props = new Dictionary<string, string>();

                    for (int k = 0; k < ts.Attributes.Count; k++)
                    {
                        string attribute = ts.Attributes[k];

                        MSExcel.Range r = sheet.get_Range(getCell(start, k + StructCol));

                        if (k == 0 && string.IsNullOrEmpty(r.FormulaLocal))
                        {
                            endRow = true;
                            break;
                        }

                        tv.Props[attribute] = r.FormulaLocal;
                    }

                    start++;

                    if (endRow)
                    {
                        break;
                    }

                    dic[ts.NodeName].Add(tv);
                }
            }

            return dic;
        }
    }
}
