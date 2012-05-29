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
        private const int SummaryRow = 1;
        private const int PackageRow = 2;
        private const int PackageCol = 1;
        private const int NamespaceRow = 2;
        private const int NamespaceCol = 2;
        private const int TypeRow = 4;
        private const int StructRow = 5;
        private const int StructCol = 1;
        private const int FreezeRow = 6;
        private const int FreezeCol = 3;
        private const int ExcelDataStart = 6;

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

            if (ofd.ShowDialog(this) == System.Windows.Forms.DialogResult.OK)
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
            ofd.Filter = "Excel files (*.xlsx)|*.xlsx";
            ofd.FilterIndex = 1;

            List<string> temp, temp2;
            Dictionary<string, TemplateStruct> list;
            Dictionary<string, List<TemplateValue>> dic;

            if (ofd.ShowDialog(this) == System.Windows.Forms.DialogResult.OK)
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
                ts.Types = new List<string>();

                list[ts.NodeName] = ts;

                for (int j = 0; j < ExcelMaxCol; j++)
                {
                    MSExcel.Range r = sheet.get_Range(getCell(StructRow, j + StructCol));

                    if (string.IsNullOrEmpty(r.Value2))
                    {
                        break;
                    }

                    ts.Attributes.Add(r.Value2);

                    MSExcel.Range r2 = sheet.get_Range(getCell(TypeRow, j + StructCol));

                    if (string.IsNullOrEmpty(r.Value2))
                    {
                        ts.Types.Add("System.String");
                    }
                    else
                    {
                        ts.Types.Add(r2.Value2);
                    }
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
















        private void button3_Click(object sender, EventArgs e)
        {
            Dictionary<string, TemplateClassInfo> list;

            OpenFileDialog ofd = new OpenFileDialog();

            ofd.Title = "选择文件";
            ofd.Filter = "Excel files (*.xlsx)|*.xlsx";
            ofd.FilterIndex = 1;

            if (ofd.ShowDialog(this) == System.Windows.Forms.DialogResult.OK)
            {
                string str = ofd.FileName;

                MSExcel.Application excel = new MSExcel.Application();

                MSExcel.Workbook wbook = excel.Workbooks.Open(str);

                list = GetClassList(wbook);

                wbook.Close(false);

                excel.Quit();

                FolderBrowserDialog fbd = new FolderBrowserDialog();

                if (fbd.ShowDialog(this) == System.Windows.Forms.DialogResult.OK)
                {
                    string root = fbd.SelectedPath;

                    TemplateClassInfo[] classes = list.Values.ToArray();

                    foreach (TemplateClassInfo info in classes)
                    {
                        WriteCodeFile(info.GetASCode(), info.ClassName, root, "as");

                        WriteCodeFile(info.GetCSCode(), info.ClassName, root, "cs");
                    }

                    MessageBox.Show("代码生成成功");
                }
                else
                {
                    MessageBox.Show("你取消了代码生成");
                }
            }
        }

        private void WriteCodeFile(string code, string className, string root, string ext)
        {
            string dir = Path.Combine(root, ext);
            Directory.CreateDirectory(dir);

            string path = Path.Combine(dir, className + "." + ext);
            File.Delete(path);

            FileStream fs = new FileStream(path, FileMode.OpenOrCreate);
            byte[] bytes = Encoding.UTF8.GetBytes(code);
            fs.Write(bytes, 0, bytes.Length);
            fs.Close();
        }

        private Dictionary<string, TemplateClassInfo> GetClassList(MSExcel.Workbook wbook)
        {
            Dictionary<string, TemplateClassInfo> list = new Dictionary<string, TemplateClassInfo>();

            int count = wbook.Worksheets.Count;

            string prop, propType, propSummary;

            for (int i = 0; i < count; i++)
            {
                MSExcel.Worksheet sheet = wbook.Worksheets[i + 1];

                TemplateClassInfo tci = new TemplateClassInfo();

                tci.ClassName = sheet.Name;

                MSExcel.Range rang = sheet.get_Range(getCell(PackageRow, PackageCol));
                if (string.IsNullOrEmpty(rang.Value2))
                {
                    tci.ASPackage = "";
                }
                else
                {
                    tci.ASPackage = rang.Value2;
                }

                rang = sheet.get_Range(getCell(NamespaceRow, NamespaceCol));
                if (string.IsNullOrEmpty(rang.Value2))
                {
                    tci.CSNamespace = "";
                }
                else
                {
                    tci.CSNamespace = rang.Value2;
                }

                list[tci.ClassName] = tci;

                for (int j = 0; j < ExcelMaxCol; j++)
                {
                    MSExcel.Range r = sheet.get_Range(getCell(StructRow, j + StructCol));

                    if (string.IsNullOrEmpty(r.Value2))
                    {
                        break;
                    }

                    prop = r.Value2;

                    MSExcel.Range r2 = sheet.get_Range(getCell(TypeRow, j + StructCol));

                    if (string.IsNullOrEmpty(r2.Value2))
                    {
                        propType = "string";
                    }
                    else
                    {
                        propType = r2.Value2;
                    }

                    MSExcel.Range r3 = sheet.get_Range(getCell(SummaryRow, j + StructCol));

                    if (string.IsNullOrEmpty(r3.Value2))
                    {
                        propSummary = "";
                    }
                    else
                    {
                        propSummary = r3.Value2;
                    }

                    tci.ASPropList.Add(string.Format("public var {0}:{1};", prop, CSharp2AS(propType)));

                    if (prop != "TemplateID" && prop != "TemplateName")
                    {
                        tci.CSPropList.Add(string.Format("public {1} {0} {2} get; set; {3}", prop, CSharp2CSharp(propType), "{", "}"));
                    }

                    tci.SummaryList.Add(propSummary);
                }
            }

            return list;
        }

        static string CSharp2CSharp(string str)
        {
            string rlt = "";

            switch (str.ToLower())
            {
                case "int":
                    rlt = "int";
                    break;
                case "string":
                    rlt = "string";
                    break;
                case "bool":
                    rlt = "bool";
                    break;
                case "float":
                    rlt = "float";
                    break;
                case "double":
                    rlt = "double";
                    break;
                case "decimal":
                    rlt = "decimal";
                    break;
                case "long":
                    rlt = "long";
                    break;
                case "uint":
                    rlt = "uint";
                    break;
                default:
                    rlt = str;
                    break;
            }

            return rlt;
        }

        static string CSharp2AS(string str)
        {
            string rlt = "";

            switch (str.ToLower())
            {
                case "int":
                    rlt = "int";
                    break;
                case "string":
                    rlt = "String";
                    break;
                case "bool":
                    rlt = "Boolean";
                    break;
                case "float":
                    rlt = "Number";
                    break;
                case "double":
                    rlt = "Number";
                    break;
                case "decimal":
                    rlt = "Number";
                    break;
                case "long":
                    rlt = "Number";
                    break;
                case "uint":
                    rlt = "uint";
                    break;
                default:
                    rlt = "int";
                    break;
            }

            return rlt;
        }
    }
}
