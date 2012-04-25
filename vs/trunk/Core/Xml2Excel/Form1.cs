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

namespace Xml2Excel
{
    public partial class Form1 : Form
    {
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
                    foreach (XmlNode item in node.ChildNodes)
                    {
                        TemplateStruct t = new TemplateStruct();

                        t.NodeName = item.LocalName;
                        t.Attributes = new List<string>();

                        foreach (XmlAttribute att in item.Attributes)
                        {
                            t.Attributes.Add(att.LocalName);
                        }

                        break;
                    }
                }


            }
        }
    }
}
