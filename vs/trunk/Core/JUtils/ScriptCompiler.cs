using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using System.Collections;
using System.IO;
using System.CodeDom.Compiler;
using Microsoft.CSharp;
using log4net;
using Microsoft.VisualBasic;

namespace JUtils
{
    public class ScriptCompiler
    {

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        /// <summary>
        /// 编译C#脚本文件
        /// </summary>
        /// <param name="path">脚本文件所在根目录</param>
        /// <param name="dllName">输出的dll文件名(包含.dll)</param>
        /// <param name="reflections">要引用的程序集名称列表</param>
        /// <returns></returns>
        public static Assembly CompileCS(string path, string dllName, string[] reflections)
        {
            if (!path.EndsWith(@"\") && !path.EndsWith(@"/")) path += "/";

            ArrayList files = ParseDirectory(new DirectoryInfo(path), "*.cs", true);

            if (files.Count == 0)
            {
                return null;
            }

            if (File.Exists(dllName))
            {
                File.Delete(dllName);
            }

            try
            {
                CodeDomProvider compiler = new CSharpCodeProvider();

                CompilerParameters param = new CompilerParameters(reflections, dllName, true);

                param.GenerateExecutable = false;
                param.GenerateInMemory = false;
                param.WarningLevel = 2;
                param.CompilerOptions = @"/lib:.";

                string[] filePaths = new string[files.Count];

                for (int i = 0; i < files.Count; i++)
                {
                    filePaths[i] = ((FileInfo)files[i]).FullName;
                }

                CompilerResults rlt = compiler.CompileAssemblyFromFile(param, filePaths);

                GC.Collect();

                if (rlt == null)
                {
                    return null;
                }

                if (rlt.Errors.HasErrors)
                {
                    foreach (CompilerError err in rlt.Errors)
                    {
                        if (err.IsWarning)
                        {
                            continue;
                        }

                        StringBuilder sb = new StringBuilder();

                        sb.Append("    ");
                        sb.Append(err.FileName);
                        sb.Append(" 行:");
                        sb.Append(err.Line);
                        sb.Append(" 列:");
                        sb.Append(err.Column);

                        if (log.IsErrorEnabled)
                        {
                            log.Error("Compilation failed, because:");
                            log.Error(err.ErrorText);
                            log.Error(sb.ToString());
                        }
                    }
                    return null;
                }

                return rlt.CompiledAssembly;
            }
            catch (Exception ex)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("Compilation", ex);
                }

                return null;
            }
        }

        /// <summary>
        /// 编译VB.NET脚本文件
        /// </summary>
        /// <param name="path">脚本文件所在根目录</param>
        /// <param name="dllName">输出的dll文件名(包含.dll)</param>
        /// <param name="reflections">要引用的程序集名称列表</param>
        /// <returns></returns>
        public static Assembly CompileVB(string path, string dllName, string[] reflections)
        {
            if (!path.EndsWith(@"\") && !path.EndsWith(@"/")) path += "/";

            ArrayList files = ParseDirectory(new DirectoryInfo(path), "*.vb", true);

            if (files.Count == 0)
            {
                return null;
            }

            if (File.Exists(dllName))
            {
                File.Delete(dllName);
            }

            try
            {
                CodeDomProvider compiler = new VBCodeProvider();

                CompilerParameters param = new CompilerParameters(reflections, dllName, true);

                param.GenerateExecutable = false;
                param.GenerateInMemory = false;
                param.WarningLevel = 2;
                param.CompilerOptions = @"/lib:.";

                string[] filePaths = new string[files.Count];

                for (int i = 0; i < files.Count; i++)
                {
                    filePaths[i] = ((FileInfo)files[i]).FullName;
                }

                CompilerResults rlt = compiler.CompileAssemblyFromFile(param, filePaths);

                GC.Collect();

                if (rlt == null)
                {
                    return null;
                }

                if (rlt.Errors.HasErrors)
                {
                    foreach (CompilerError err in rlt.Errors)
                    {
                        if (err.IsWarning)
                        {
                            continue;
                        }

                        StringBuilder sb = new StringBuilder();

                        sb.Append("    ");
                        sb.Append(err.FileName);
                        sb.Append(" 行:");
                        sb.Append(err.Line);
                        sb.Append(" 列:");
                        sb.Append(err.Column);

                        if (log.IsErrorEnabled)
                        {
                            log.Error("Compilation failed, because:");
                            log.Error(err.ErrorText);
                            log.Error(sb.ToString());
                        }
                    }
                    return null;
                }

                return rlt.CompiledAssembly;
            }
            catch (Exception ex)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("Compilation", ex);
                }

                return null;
            }
        }

        private static ArrayList ParseDirectory(DirectoryInfo dir, string filter, bool deep)
        {
            ArrayList files = new ArrayList();

            if (!dir.Exists)
            {
                return files;
            }

            if (deep)
            {
                files.AddRange(dir.GetFiles(filter, SearchOption.AllDirectories));
            }
            else
            {
                files.AddRange(dir.GetFiles(filter, SearchOption.TopDirectoryOnly));
            }

            return files;
        }
    }
}
