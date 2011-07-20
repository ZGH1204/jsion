using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using System.Runtime.InteropServices;
using Microsoft.VisualBasic.CompilerServices;

namespace Sjs.Common
{
    public class INIFileHelper
    {
        #region " 引入相关dll "

        [DllImport("KERNEL32.DLL", EntryPoint = "GetPrivateProfileIntA", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Ansi, ExactSpelling = true)]
        private static extern int GetPrivateProfileInt(string lpApplicationName, string lpKeyName, int nDefault, string lpFileName);

        [DllImport("KERNEL32.DLL", EntryPoint = "GetPrivateProfileSectionsNamesA", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Ansi, ExactSpelling = true)]
        private static extern int GetPrivateProfileSectionsNames(byte[] lpszReturnBuffer, int nSize, string lpFileName);

        [DllImport("KERNEL32.DLL", EntryPoint = "GetPrivateProfileStringA", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Ansi, ExactSpelling = true)]
        private static extern int GetPrivateProfileString(string lpApplicationName, string lpKeyName, string lpDefault, StringBuilder lpReturnedString, int nSize, string lpFileName);

        [DllImport("KERNEL32.DLL", EntryPoint = "GetPrivateProfileStructA", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Ansi, ExactSpelling = true)]
        private static extern int GetPrivateProfileStruct(string lpszSections, string lpszKey, byte[] lpStruct, int uSizeStruct, string szFile);

        [DllImport("KERNEL32.DLL", EntryPoint = "WritePrivateProfileSectionsA", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Ansi, ExactSpelling = true)]
        private static extern int WritePrivateProfileSections(string lpAppName, string lpString, string lpFileName);

        [DllImport("KERNEL32.DLL", EntryPoint = "WritePrivateProfileStringA", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Ansi, ExactSpelling = true)]
        private static extern int WritePrivateProfileString(string lpApplicationName, string lpKeyName, string lpString, string lpFileName);

        [DllImport("KERNEL32.DLL", EntryPoint = "WritePrivateProfileStructA", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Ansi, ExactSpelling = true)]
        private static extern int WritePrivateProfileStruct(string lpszSections, string lpszKey, byte[] lpStruct, int uSizeStruct, string szFile);


        #endregion


        private string _Filename;   //INI文件名
        private string _Sections;   //INI文件中配置参数的组别片段
        private const int MAX_ENTRY = 32768; //最大字符数


        public INIFileHelper(string strFile)
        {
            this.Filename = strFile;
        }

        #region" INI操作类的属性 "

        /// <summary>
        /// INI文件名
        /// </summary>
        public string Filename
        {
            get
            {
                return this._Filename;
            }
            set
            {
                this._Filename = value;
            }
        }

        /// <summary>
        /// INI文件中配置参数的组别片段
        /// </summary>
        public string Sections
        {
            get
            {
                return this._Sections;
            }
            set
            {
                this._Sections = value;
            }
        }


        #endregion


        #region" INI操作类的Read相关方法 "

        // Read相关方法中的 DefaultValue是 在INI文件中找不到相关配置 时的返回值
        //ReadBoolean是读取bool类型的配置参数，ReadByteArray是读取 byte[]类型的配置参数
        //ReadInteger是读取int类型的配置参数。。。。依次类推

        public bool ReadBoolean(string Key)
        {
            return this.ReadBoolean(this.Sections, Key);
        }

        public bool ReadBoolean(string Key, bool DefaultValue)
        {
            return this.ReadBoolean(this.Sections, Key, DefaultValue);
        }

        public bool ReadBoolean(string Sections, string Key)
        {
            return this.ReadBoolean(Sections, Key, false);
        }

        public bool ReadBoolean(string Sections, string Key, bool DefaultValue)
        {
            return bool.Parse(this.ReadString(Sections, Key, DefaultValue.ToString()));
        }

        public byte[] ReadByteArray(string Key, int Length)
        {
            return this.ReadByteArray(this.Sections, Key, Length);
        }

        /// <summary>
        /// 读取数据级别的Byte数组
        /// </summary>
        /// <param name="Sections"></param>
        /// <param name="Key"></param>
        /// <param name="Length"></param>
        /// <returns></returns>
        public byte[] ReadByteArray(string Sections, string Key, int Length)
        {
            byte[] buffer1;
            if (Length > 0)
            {
                try
                {
                    byte[] buffer2 = new byte[(Length - 1) + 1];
                    if (INIFileHelper.GetPrivateProfileStruct(Sections, Key, buffer2, buffer2.Length, this.Filename) == 0)
                    {
                        return null;
                    }
                    return buffer2;
                }
                catch (Exception exception1)
                {
                    ProjectData.SetProjectError(exception1);
                    buffer1 = null;
                    ProjectData.ClearProjectError();
                    return buffer1;
                }
            }
            else
            {
                return null;
            }

        }


        public int ReadInteger(string Key)
        {
            return this.ReadInteger(Key, 0);
        }

        public int ReadInteger(string Key, int DefaultValue)
        {
            return this.ReadInteger(this.Sections, Key, DefaultValue);
        }

        public int ReadInteger(string Sections, string Key)
        {
            return this.ReadInteger(Sections, Key, 0);
        }

        public int ReadInteger(string Sections, string Key, int DefaultValue)
        {
            int num1;
            try
            {
                num1 = INIFileHelper.GetPrivateProfileInt(Sections, Key, DefaultValue, this.Filename);
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                num1 = DefaultValue;
                ProjectData.ClearProjectError();
                return num1;
            }
            return num1;
        }

        public long ReadLong(string Key)
        {
            return this.ReadLong(Key, (long)0);
        }

        public long ReadLong(string Key, long DefaultValue)
        {
            return this.ReadLong(this.Sections, Key, DefaultValue);
        }

        public long ReadLong(string Sections, string Key)
        {
            return this.ReadLong(Sections, Key, 0);
        }

        public long ReadLong(string Sections, string Key, long DefaultValue)
        {
            return long.Parse(this.ReadString(Sections, Key, DefaultValue.ToString()));
        }

        public string ReadString(string Key)
        {
            return this.ReadString(this.Sections, Key);
        }

        public string ReadString(string Sections, string Key)
        {
            return this.ReadString(Sections, Key, "");
        }

        /// <summary>
        /// 运用DLL引入的方法读取INI配置文件的信息
        /// </summary>
        /// <param name="Sections"></param>
        /// <param name="Key"></param>
        /// <param name="DefaultValue"></param>
        /// <returns></returns>
        public string ReadString(string Sections, string Key, string DefaultValue)
        {
            string text1;
            try
            {
                StringBuilder builder1 = new StringBuilder(MAX_ENTRY);
                int num1 = INIFileHelper.GetPrivateProfileString(Sections, Key, DefaultValue, builder1, MAX_ENTRY, this.Filename);
                text1 = builder1.ToString();
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                text1 = DefaultValue;
                ProjectData.ClearProjectError();
                return text1;

            }
            return text1;
        }

        #endregion


        #region" INI操作类的Write相关方法 "

        public bool Write(string Key, bool Value)
        {
            return this.Write(this.Sections, Key, Value);
        }

        public bool Write(string Key, byte[] Value)
        {
            return this.Write(this.Sections, Key, Value);
        }

        public bool Write(string Key, string Value)
        {
            return this.Write(this.Sections, Key, Value);
        }

        public bool Write(string Key, int Value)
        {
            return this.Write(this.Sections, Key, Value);
        }

        public bool Write(string Key, long Value)
        {
            return this.Write(this.Sections, Key, Value);
        }

        public bool Write(string Sections, string Key, byte[] Value)
        {
            bool flag1;
            try
            {
                flag1 = INIFileHelper.WritePrivateProfileStruct(Sections, Key, Value, Value.Length, this.Filename) != 0;
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                flag1 = false;
                ProjectData.ClearProjectError();
                return flag1;
            }
            return flag1;
        }

        public bool Write(string Sections, string Key, bool Value)
        {
            return this.Write(Sections, Key, Value.ToString());
        }

        public bool Write(string Sections, string Key, int Value)
        {
            bool flag1;
            try
            {
                flag1 = INIFileHelper.WritePrivateProfileString(Sections, Key, Value.ToString(), this.Filename) != 0;
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                flag1 = false;
                ProjectData.ClearProjectError();
                return flag1;
            }
            return flag1;
        }

        public bool Write(string Sections, string Key, long Value)
        {
            return this.Write(Sections, Key, Value.ToString());
        }

        public bool Write(string Sections, string Key, string Value)
        {
            bool flag1;
            try
            {
                flag1 = INIFileHelper.WritePrivateProfileString(Sections, Key, Value, this.Filename) != 0;
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                flag1 = false;
                ProjectData.ClearProjectError();
                return flag1;
            }
            return flag1;
        }

        #endregion


        #region" INI操作类的Delete相关方法 "

        public bool DeleteKey(string Key)
        {
            bool flag1;
            try
            {
                flag1 = INIFileHelper.WritePrivateProfileString(this.Sections, Key, null, this.Filename) != 0;
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                flag1 = false;
                ProjectData.ClearProjectError();
                return flag1;
            }
            return flag1;
        }

        public bool DeleteKey(string Section, string Key)
        {
            bool flag1;
            try
            {
                flag1 = INIFileHelper.WritePrivateProfileString(Sections, Key, null, this.Filename) != 0;
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                flag1 = false;
                ProjectData.ClearProjectError();
                return flag1;
            }
            return flag1;
        }

        public bool DeleteSections(string Section)
        {
            bool flag1;
            try
            {
                flag1 = INIFileHelper.WritePrivateProfileSections(Sections, null, this.Filename) != 0;
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                flag1 = false;
                ProjectData.ClearProjectError();
                return flag1;
            }
            return flag1;
        }

        #endregion


        public ArrayList GetSectionsNames()
        {
            int num1;
            ArrayList list1 = new ArrayList();
            byte[] buffer1 = new byte[MAX_ENTRY];
            int num2 = 0;
            try
            {
                num1 = INIFileHelper.GetPrivateProfileSectionsNames(buffer1, MAX_ENTRY, this.Filename);
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
                return list1;
            }
            ASCIIEncoding encoding1 = new ASCIIEncoding();
            if (num1 > 0)
            {
                string text1 = encoding1.GetString(buffer1);
                num1 = 0;
                num2 = -1;
                while (true)
                {
                    num1 = text1.IndexOf('\0', (int)(num2 + 1));
                    if (((num1 - num2) == 1) || (num1 == -1))
                    {
                        return list1;
                    }
                    try
                    {
                        list1.Add(text1.Substring(num2 + 1, num1 - num2));
                    }
                    catch (Exception exception2)
                    {
                        ProjectData.SetProjectError(exception2);
                        ProjectData.ClearProjectError();
                    }
                    num2 = num1;
                }
            }
            return list1;
        }

    }
}
