package jcore.org.moduls
{
	import flash.system.ApplicationDomain;
	
	import jutils.org.reflection.Assembly;

	public dynamic class ModuleInfo
	{
		/**
		 * 模块文件
		 */		
		public var file:String;
		
		/**
		 * 模块文件是否加密
		 */		
		public var crypt:Boolean;
		
		/**
		 * 模块标识
		 */		
		public var id:String;
		
		/**
		 * 是否初始化启动模块
		 */		
		public var startup:Boolean;
		
		/**
		 * 是否在加载完成后发送安装消息
		 */		
		public var installAfterLoaded:Boolean;
		
		/**
		 * 模块是否已加载到内存
		 */		
		public var isLoaded:Boolean;
		
		/**
		 * 模块加载错误
		 */		
		public var isError:Boolean;
		
		/**
		 * 类路径
		 */		
		public var cls:String;
		
		/**
		 * 加载到的目标程序域
		 * <p>_self:指示加载到当前应用程序域中，默认值。</p>
		 * <p>_blank:指示加载到新的应用程序域中。</p>
		 * <p>_child:指示加载到当前程序域子域中。</p>
		 */		
		public var target:String = ModuleTarget.Self;
		
		/**
		 * 模块所在域
		 */		
		public var domain:ApplicationDomain;
		
		/**
		 * 程序集信息
		 */		
		public var assembly:Assembly;
	}
}