package jutils.org.util
{
	import flash.system.ApplicationDomain;

	/**
	 * 应用程序域工具
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public class AppDomainUtil
	{
		/**
		 * 应用程序域列表
		 */		
		private static var domains:Array = [ApplicationDomain.currentDomain];
		
		/**
		 * 注册应用程序域到列表
		 * @param domain
		 * 
		 */		
		public static function registeAppDomain(domain:ApplicationDomain):void
		{
			if(domain == null || domains.indexOf(domain) != -1) return;
			
			domains.push(domain);
		}
		
		/**
		 * 从列表中移除应用程序域，其中当前域无法被移除。
		 * @param domain
		 * 
		 */		
		public static function removeAppDomain(domain:ApplicationDomain):void
		{
			if(domain == ApplicationDomain.currentDomain) return;
			
			ArrayUtil.remove(domains, domain);
		}
		
		/**
		 * 获取所有应用程序域列表
		 * @return 程序域列表
		 * 
		 */		
		public static function getAllDomains():Array
		{
			return domains;
		}
		
		/**
		 * 获取应用程序域内的类引用
		 * @param clsStr 类路径
		 * @param domain 应用程序域
		 * @return 类引用，不存在时返回null。
		 * 
		 */		
		public static function getClass(clsStr:String):Class
		{
			var cls:Class;
			
			for each(var domain:ApplicationDomain in domains)
			{
				if(domain.hasDefinition(clsStr))
					cls = domain.getDefinition(clsStr) as Class;
				if(cls) break;
			}
			
			return cls;
		}
		
		/**
		 * 获取指定对象
		 * @param str 对象的字符串表示形式
		 * @return 对象
		 * 
		 */		
		public static function getDefine(str:String):*
		{
			var obj:Object;
			
			for each(var domain:ApplicationDomain in domains)
			{
				obj = domain.getDefinition(str);
				if(obj) break;
			}
			
			return obj;
		}
		
		/**
		 * 获取指定应用程序域内的类引用，未指定时使用当前应用程序域。
		 * @param clsStr 类路径
		 * @param domain 应用程序域
		 * @return 类引用或null(无相应类时)
		 * 
		 */		
		public static function getClsByDomain(clsStr:String, domain:ApplicationDomain):Class
		{
			var dm:ApplicationDomain = domain || ApplicationDomain.currentDomain;
			
			return dm.getDefinition(clsStr) as Class;
		}
	}
}