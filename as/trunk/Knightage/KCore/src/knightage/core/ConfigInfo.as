package knightage.core
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
		 * Loading背景图片
		 */		
		public var LoadingGround:String;
		
		/**
		 * 内城背景图
		 */		
		public var InnerCityGround:String;
		
		/**
		 * 世界地图
		 */		
		public var WorldGround:String;
		
		/**
		 * Mission背景图片
		 */		
		public var MissionGround:String;
		
		/**
		 * 是否是调试模式
		 */		
		public var Debug:Boolean;
		
		/**
		 * 服务器IP
		 */		
		public var SrvIP:String;
		/**
		 * 服务器端口
		 */		
		public var SrvPort:int;
		
		
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
		
		/**
		 * fps
		 */
		public var fps:int;
	}
}