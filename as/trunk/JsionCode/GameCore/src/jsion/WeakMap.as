package jsion
{
	import flash.utils.Dictionary;
	
	/**
	 * 弱引用哈希表
	 * @author Jsion
	 * 
	 */	
	public class WeakMap
	{
		
		private var dic:Dictionary;
		
		public function WeakMap()
		{
			super();
			dic = new Dictionary(true);
		}
		
		/**
		 * 插入一个键/值对
		 * @param key
		 * @param value
		 * 
		 */		
		public function put(key:*, value:*):void
		{
			var wd:Dictionary = new Dictionary(true);
			wd[value] = null;
			dic[key] = wd;
		}
		
		/**
		 * 获取指定Key对应的值
		 * @param key
		 */		
		public function getValue(key:*):*
		{
			var wd:Dictionary = dic[key];
			if(wd)
			{
				for(var v:* in wd)
				{
					return v;
				}
			}
			
			dic[key] = null;
			delete dic[key];
			
			return undefined;
		}
		
		/**
		 * 移除指定Key对应的值，并返回该值。
		 * @param key
		 */		
		public function remove(key:*):*
		{
			var value:* = getValue(key);
			delete dic[key];
			return value;
		}
	}
}