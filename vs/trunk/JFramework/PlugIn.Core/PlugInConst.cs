using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PlugIn.Core
{
    public class PlugInConst
    {
        /// <summary>
        /// 插件根节点名称
        /// </summary>
        public const string RootElement = "PlugIn";

        /// <summary>
        /// 运行时支持
        /// </summary>
        public const string Runtime = "Runtime";

        /// <summary>
        /// 运行时的导入程序集
        /// </summary>
        public const string RuntimeImport = "Import";

        /// <summary>
        /// 运行时的导入程序集定义的解析器
        /// </summary>
        public const string RuntimeImportDoozer = "Doozer";

        //TODO:缺少运行时导入程序集的解析器

        /// <summary>
        /// 扩展点路径
        /// </summary>
        public const string Path = "Path";

        /// <summary>
        /// 清单
        /// </summary>
        public const string Manifest = "Manifest";

        /// <summary>
        /// 身份标识
        /// </summary>
        public const string ManifestIdentity = "Identity";

        /// <summary>
        /// 依赖
        /// </summary>
        public const string ManifestDependency = "Dependency";

        /// <summary>
        /// 冲突
        /// </summary>
        public const string ManifestConflict = "Conflict";

        /// <summary>
        /// 同步插件系统版本号配置字符串
        /// </summary>
        public const string CoreVersion = "CoreVersion";
    }
}
