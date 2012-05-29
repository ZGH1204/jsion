using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Xml2Excel.Core
{
    public class TemplateClassInfo
    {
        private const string ASSummaryStart = "/**";
        private const string ASSummary = " * ";
        private const string ASSummaryEnd = " */";
        /// <summary>
        /// 0左大括号
        /// 1右大括号
        /// </summary>
        private const string ASCode = "package {2}\r\n{0}\r\n    public class {3}\r\n    {0}\r\n{4}\r\n    {1}\r\n{1}";



        private const string CSSummaryStart = "/// <summary>";
        private const string CSSummary = "/// ";
        private const string CSSummaryEnd = "/// </summary>";
        /// <summary>
        /// 0左大括号
        /// 1右大括号
        /// </summary>
        private const string CSCode = "using System;\r\nusing System.Collections.Generic;\r\nusing System.Text;\r\n\r\nnamespace {2}\r\n{0}\r\n    public class {3}\r\n    {0}\r\n{4}\r\n    {1}\r\n{1}";

        public string ClassName;

        public string ASPackage;

        public string CSNamespace;

        public List<string> ASPropList = new List<string>();
        public List<string> CSPropList = new List<string>();
        public List<string> SummaryList = new List<string>();

        public string GetASCode()
        {
            return CombinCode(ASPackage, ASCode, ASPropList, SummaryList, ASSummaryStart, ASSummary, ASSummaryEnd);
        }

        private string CombinCode(string ns, string formatCode, List<string> propList, List<string> summary, string summaryStart, string summaryBody, string summaryEnd)
        {
            StringBuilder sb = new StringBuilder();

            AppendASSummary(sb, summary[0], summaryStart, summaryBody, summaryEnd);
            sb.Append(string.Format("\r\n        {0}\r\n", propList[0]));

            for (int i = 1; i < ASPropList.Count; i++)
            {
                AppendASSummary(sb, summary[i], summaryStart, summaryBody, summaryEnd);
                sb.Append(string.Format("\r\n        {0}\r\n", propList[i]));
            }

            return string.Format(formatCode, "{", "}", ns, ClassName, sb.ToString());
        }

        private void AppendASSummary(StringBuilder sb, string summary, string summaryStart, string summaryBody, string summaryEnd)
        {
            string[] list = summary.Split(new char[] { '\n' }, StringSplitOptions.RemoveEmptyEntries);

            sb.Append("\r\n        " + summaryStart);

            if (list.Length > 0 && string.IsNullOrEmpty(list[0]) == false)
            {
                foreach (string str in list)
                {
                    sb.Append(string.Format("\r\n        {0}{1}", summaryBody, str));
                }
            }
            else
            {
                sb.Append("\r\n        " + summaryBody);
            }

            sb.Append("\r\n        " + summaryEnd);
        }

        public string GetCSCode()
        {
            return CombinCode(CSNamespace, CSCode, CSPropList, SummaryList, CSSummaryStart, CSSummary, CSSummaryEnd);
        }
    }
}
