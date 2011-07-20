package jutils.org.util
{
	import flash.utils.Dictionary;

	/**
	 * 对象工具
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public class InstanceUtil
	{
		/**
		 * 单例对象引用
		 */		
		private static var instances:Dictionary = new Dictionary();
		
		/**
		 * 创建或获取指定类的单例对象
		 * @param obj 类引用或类路径
		 * @return 单例对象
		 * 
		 */		
		public static function createSingletion(obj:*):*
		{
			return createUnique(obj, "singletion");
		}
		
		/**
		 * 移除并返回指定类的单例对象
		 * @param obj 类引用或类路径
		 * @return 单例对象
		 * 
		 */		
		public static function removeSingletion(obj:*):*
		{
			return removeUnique(obj, "singletion");
		}
		
		/**
		 * 创建指定类的对象
		 * @param obj 类引用或类路径
		 * @return 类对象
		 * 
		 */		
		public static function createInstance(obj:*):*
		{
			if(obj is String) obj = getClass(obj as String);
			
			if(obj is Class)
			{
				return new obj;
			}
			
			return obj;
		}
		
		/**
		 * 创建或获取指定类和Key的唯一对象
		 * @param obj 类引用或类路径
		 * @param key 对象键
		 * @return 唯一对象
		 * 
		 */		
		public static function createUnique(obj:*, key:String):*
		{
			if(obj is String) obj = getClass(obj as String);
			
			if(obj is Class)
			{
				if(instances[obj] == null) instances[obj] = new Dictionary();
				
				if(instances[obj][key] == null) instances[obj][key] = createInstance(obj);
				
				return instances[obj][key];
			}
			
			return obj;
		}
		
		/**
		 * 移除并返回指定类和Key的唯一对象
		 * @param obj 类引用或类路径
		 * @param key 对象键
		 * @return 唯一对象
		 * 
		 */		
		public static function removeUnique(obj:*, key:String):*
		{
			if(instances[obj] == null || instances[obj][key] == null) return null;
			
			var dic:Dictionary = instances[obj] as Dictionary;
			
			var rlt:* = DictionaryUtil.delKey(dic, key);
			
			if(DictionaryUtil.hasKey(dic) == false) delete instances[obj];
			
			return rlt;
		}
		
		/**
		 * 从当前程序域列表中获取指定类
		 * @param clsStr 类路径
		 * @return 类引用
		 * 
		 */		
		private static function getClass(clsStr:String):Class
		{
			return AppDomainUtil.getClass(clsStr);
		}
	}
}