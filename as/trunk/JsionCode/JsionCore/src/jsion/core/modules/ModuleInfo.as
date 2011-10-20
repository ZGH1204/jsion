package jsion.core.modules
{
	public class ModuleInfo
	{
		/**
		 * 模块ID
		 */		
		public var id:String;
		
		/**
		 * 继承自BaseModule的模块完整类路径
		 */		
		public var cls:String;
		
		/**
		 * 模块文件地址
		 */		
		public var url:String;
		
		/**
		 * 指示模块文件是否加密过
		 */		
		public var crypted:Boolean;
		
		/**
		 * 指示当前模块是否为自启动加载模块
		 */		
		public var autoLoad:Boolean;
		
		/**
		 * 指示当前模块要加载到的目标应用程序域，目标应用程序域可能的值请参考ModuleTarget中的常量。
		 */		
		public var target:String;
	}
}