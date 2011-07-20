using System;
using System.Collections;

namespace Sjs.Common
{
    /// <summary>
    /// CalUtility 的摘要说明
    /// 读算式辅助工具
    /// </summary>
    public class CalUtility
    {
        System.Text.StringBuilder StrB;
        private int iCurr = 0;
        private int iCount = 0;
        /// <summary>
        /// 构造方法
        /// </summary>
        public CalUtility(string calStr)
        {
            StrB = new System.Text.StringBuilder(calStr.Trim());
            iCount = System.Text.Encoding.Default.GetByteCount(calStr.Trim());
        }

        /// <summary>
        /// 取段,自动分析数值或计算符
        /// </summary>
        /// <returns></returns>\
        public string getItem()
        {
            //结束了
            if (iCurr == iCount)
                return "";
            char ChTmp = StrB[iCurr];
            bool b = IsNum(ChTmp);
            if (!b)
            {
                iCurr++;
                return ChTmp.ToString();
            }
            string strTmp = "";
            while (IsNum(ChTmp) == b && iCurr < iCount)
            {
                ChTmp = StrB[iCurr];
                if (IsNum(ChTmp) == b)
                    strTmp += ChTmp;
                else
                    break;
                iCurr++;
            }
            return strTmp;
        }

        /// <summary>
        /// 是否是数字
        /// </summary>
        /// <param name="c">内容</param>
        /// <returns></returns>
        public bool IsNum(char c)
        {
            if ((c >= '0' && c <= '9') || c == '.')
            {
                return true;
            }
            else
            {
                return false;
            }
        }


        /// <summary>
        /// 是否是数字
        /// </summary>
        /// <param name="c">内容</param>
        /// <returns></returns>
        public bool IsNum(string c)
        {
            if (c.Equals(""))
                return false;
            if ((c[0] >= '0' && c[0] <= '9') || c[0] == '.')
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// 比较str1和str2两个运算符的优先级,ture表示str1高于str2,false表示str1低于str2
        /// </summary>
        /// <param name="str1">计算符1</param>
        /// <param name="str2">计算符2</param>
        /// <returns></returns>
        public bool Compare(string str1, string str2)
        {
            return getPriority(str1) >= getPriority(str2);
        }


        /// <summary>
        /// 取得计算符号的优先级
        /// </summary>
        /// <param name="str">计算符</param>
        /// <returns></returns>	
        public int getPriority(string str)
        {
            if (str.Equals(""))
            {
                return -1;
            }
            if (str.Equals("("))
            {
                return 0;
            }
            if (str.Equals("+") || str.Equals("-"))
            {
                return 1;
            }
            if (str.Equals("*") || str.Equals("/"))
            {
                return 2;
            }
            if (str.Equals(")"))
            {
                return 0;
            }
            return 0;
        }
    }


    /// <summary>
    /// IOper 的摘要说明
    /// 计算符接口
    /// </summary>	
    public interface IOper
    {
        /// <summary>
        /// 计算符计算接口计算方法
        /// </summary>
        /// <param name="o1">参数1</param>
        /// <param name="o2">参数2</param>
        /// <returns></returns>
        object Oper(object o1, object o2);
    }

    /// <summary>
    /// Opers 的摘要说明
    /// 各类计算符的接口实现,加减乘除
    /// </summary>
    public class OperAdd : IOper
    {
        public OperAdd()
        {
        }
        #region IOper 成员
        public object Oper(object o1, object o2)
        {
            Decimal d1 = Decimal.Parse(o1.ToString());
            Decimal d2 = Decimal.Parse(o2.ToString());
            return d1 + d2;
        }
        #endregion
    }

    public class OperDec : IOper
    {
        public OperDec()
        {
        }
        #region IOper 成员

        public object Oper(object o1, object o2)
        {
            Decimal d1 = Decimal.Parse(o1.ToString());
            Decimal d2 = Decimal.Parse(o2.ToString());
            return d1 - d2;
        }
        #endregion
    }


    public class OperRide : IOper
    {
        public OperRide()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }
        #region IOper 成员

        public object Oper(object o1, object o2)
        {
            Decimal d1 = Decimal.Parse(o1.ToString());
            Decimal d2 = Decimal.Parse(o2.ToString());
            return d1 * d2;
        }
        #endregion
    }

    public class OperDiv : IOper
    {
        public OperDiv()
        {
        }
        #region IOper 成员

        public object Oper(object o1, object o2)
        {
            Decimal d1 = Decimal.Parse(o1.ToString());
            Decimal d2 = Decimal.Parse(o2.ToString());
            return d1 / d2;
        }

        #endregion
    }



    /// <summary>
    /// OperFactory 的摘要说明。
    /// 计算符接口工厂
    /// </summary>
    public class OperFactory
    {
        public OperFactory()
        {
        }
        public IOper CreateOper(string Oper)
        {
            if (Oper.Equals("+"))
            {
                IOper p = new OperAdd();
                return p;
            }
            if (Oper.Equals("-"))
            {
                IOper p = new OperDec();
                return p;
            }
            if (Oper.Equals("*"))
            {
                IOper p = new OperRide();
                return p;
            }
            if (Oper.Equals("/"))
            {
                IOper p = new OperDiv();
                return p;
            }
            return null;
        }
    }


    /// <summary>
    /// Arithmetic 的摘要说明
    /// 计算实现主类
    /// </summary>
    public class Arithmetic
    {
        /// <summary>
        /// 算术符栈
        /// </summary>
        private ArrayList HList;
        /// <summary>
        /// 数值栈
        /// </summary>
        public ArrayList Vlist;
        /// <summary>
        /// 读算试工具
        /// </summary>
        private CalUtility cu;
        /// <summary>
        /// 运算操作器工厂
        /// </summary>
        private OperFactory of;
        /// <summary>
        /// 构造方法
        /// </summary>
        /// <param name="str">算式</param>
        public Arithmetic(string str)
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
            HList = new ArrayList();
            Vlist = new ArrayList();
            of = new OperFactory();
            cu = new CalUtility(str);
        }


        /// <summary>
        /// 开始计算
        /// </summary>
        public object DoCal()
        {
            string strTmp = cu.getItem();
            while (true)
            {
                if (cu.IsNum(strTmp))
                {
                    //如果是数值,则写入数据栈
                    Vlist.Add(strTmp);
                }
                else
                {
                    //数值
                    Cal(strTmp);
                }
                if (strTmp.Equals(""))
                    break;
                strTmp = cu.getItem();
            }
            return Vlist[0];
        }


        /// <summary>
        /// 计算
        /// </summary>
        /// <param name="str">计算符</param>
        /// 
        private void Cal(string str)
        {
            //符号表为空,而且当前符号为"",则认为已经计算完毕
            if (str.Equals("") && HList.Count == 0)
                return;
            if (HList.Count > 0 && Vlist.Count > 1)
            {
                //符号是否可以对消？
                if (HList[HList.Count - 1].ToString().Equals("(") && str.Equals(")"))
                {
                    HList.RemoveAt(HList.Count - 1);
                    if (HList.Count > 0)
                    {
                        str = HList[HList.Count - 1].ToString();
                        //HList.RemoveAt(HList.Count-1);
                        Cal(str);
                    }
                    return;
                }
                //比较优先级
                if (cu.Compare(HList[HList.Count - 1].ToString(), str))
                {
                    //如果优先,则计算
                    IOper p = of.CreateOper(HList[HList.Count - 1].ToString());
                    if (p != null)
                    {
                        Vlist[Vlist.Count - 2] = p.Oper(Vlist[Vlist.Count - 2], Vlist[Vlist.Count - 1]);
                        HList.RemoveAt(HList.Count - 1);
                        Vlist.RemoveAt(Vlist.Count - 1);
                        Cal(str);
                    }
                    return;
                }
                if (!str.Equals(""))
                    HList.Add(str);
            }
            else
            {
                if (!str.Equals(""))
                    HList.Add(str);
            }
        }
    }



}
