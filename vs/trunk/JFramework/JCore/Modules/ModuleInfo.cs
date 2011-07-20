
namespace JCore.Modules
{
    public class ModuleInfo
    {
        /// <summary>
        /// 模块全局唯一ID
        /// </summary>
        public string ID { get; set; }

        /// <summary>
        /// 模块dll文件
        /// </summary>
        public string File { get; set; }

        /// <summary>
        /// 指示是否为启动模块
        /// </summary>
        public bool Startup { get; set; }

        /// <summary>
        /// 模块类
        /// </summary>
        public string CLS { get; set; }

        /// <summary>
        /// 模块所在文件夹路径
        /// </summary>
        public string CurDir { get; set; }
    }
}
