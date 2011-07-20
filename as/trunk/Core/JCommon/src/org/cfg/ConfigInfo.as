package org.cfg
{
	/**
	 * 配置信息类
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public dynamic class ConfigInfo
	{
		/**
		 * 版本
		 */		
		public var Ver:String;
		/**
		 * 版权信息
		 */		
		public var Copyright:String;
		
		/**
		 * 代理商
		 */		
		public var Agent:String;
		/**
		 * 代理商ID
		 */		
		public var AgentID:int;
		
		/**
		 * 语言版本
		 */		
		public var Language:String;
		
		/**
		 * 游戏宽度
		 */		
		public var GameWidth:int;
		/**
		 * 游戏高度
		 */		
		public var GameHeight:int;
		
		/**
		 * 服务器IP
		 */		
		public var SrvIP:String;
		/**
		 * 服务器端口
		 */		
		public var SrvPort:int;
		
		/**
		 * 用户插件目录
		 */		
		public var UserPlugInsDir:String;
		
		/**
		 * 用户插件列表文件
		 */		
		public var UserPlugInsList:String;
		
		/**
		 * 登陆游戏地址
		 */		
		public var LoginUrl:String;
		/**
		 * 充值地址
		 */		
		public var PayUrl:String;
		/**
		 * 论坛地址
		 */		
		public var ForumUrl:String;
		/**
		 * 资源根目录，以"/"结尾。
		 */		
		public var ResRoot:String;
	}
}