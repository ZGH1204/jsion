package jsion.utils
{
	import flash.utils.*;
	
	/**
	 * 字典工具
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public final class DictionaryUtil
	{
		/**
		 * 指示当前字典中是否存在键/值对
		 * @param dic 字典对象
		 * @return 是否存在键/值对
		 * 
		 */		
		public static function hasKey(dic:Dictionary):Boolean
		{
			var rlt:Boolean = false;
			
			for (var key:* in  dic)
			{
				rlt = true;
				break;
			}
			
			return rlt;
		}
		
		/**
		 * 指示当前字典中是否存在键/值对
		 * @param dic 字典对象
		 * @return 是否存在键/值对
		 * 
		 */		
		public static function hasValue(dic:Dictionary):Boolean
		{
			var rlt:Boolean = false;
			
			for each(var val:* in  dic)
			{
				rlt = true;
				break;
			}
			
			return rlt;
		}
		
		/**
		 * 指示当前字典中是否存在指定的字典键
		 * @param dic 字典对象
		 * @param key 字典键
		 * @return true表示存在，false表示不存在。
		 * 
		 */		
		public static function containsKey(dic:Dictionary, key:*):Boolean
		{
			for(var k:* in dic)
			{
				if(key == k) return true;
			}
			
			return false;
		}
		
		/**
		 * 指示当前字典中是否存在指定的字典值
		 * @param dic 字典对象
		 * @param value 字典值
		 * @return true表示存在，false表示不存在。
		 * 
		 */		
		public static function containsValue(dic:Dictionary, value:*):Boolean
		{
			for each(var v:* in dic)
			{
				if(v == value) return true;
			}
			
			return false;
		}
		
		/**
		 * 返回当前字典中指定值的字典键
		 * @param dic 字典对象
		 * @param value 字典值
		 * @return 存在时返回对应字典键，不存在则返回null。
		 * 
		 */		
		public static function getKey(dic:Dictionary, value:*):*
		{
			for(var k:* in dic)
			{
				if(dic[k] == value) return k;
			}
			
			return null;
		}
		
		/**
		 * 返回字典的 Key 列表
		 * @param dic 要获取列表的字典
		 * @return Key 列表
		 * 
		 */		
		public static function getKeys(dic:Dictionary):Array
		{
			var list:Array = [];
			
			for(var key:* in dic)
			{
				if(dic[key] is Function) continue;
				list.push(key);
			}
			
			return list;
		}
		
		/**
		 * 返回字典的 Value 列表
		 * @param dic 要获取列表的字典
		 * @return Value 列表
		 * 
		 */		
		public static function getValues(dic:Dictionary):Array
		{
			var list:Array = [];
			
			for each(var key:* in dic)
			{
				if(key is Function) continue;
				list.push(key);
			}
			
			return list;
		}
		
		/**
		 * 从当前 Dictionary 字典对象中移除指定字典键对象及其引用
		 * @param dic 字典对象
		 * @param key 字典键对象
		 * @return 字典键对象的引用对象
		 * 
		 */		
		public static function delKey(dic:Dictionary, key:*):*
		{
			if(dic == null) return null;
			
			var rlt:* = dic[key];
			
			delete dic[key];
			
			return rlt;
		}
		
		/**
		 * 从当前 Dictionary 字典对象中移除指定对象引用及其字典键
		 * @param dic 字典对象
		 * @param value 指定对象
		 * @return 移除个数
		 * 
		 */		
		public static function delValue(dic:Dictionary, value:*):int
		{
			var list:Array = [];
			
			for(var key:* in dic)
			{
				if(dic[key] == value)
				{
					list.push(key);
				}
			}
			
			for(var i:int = 0; i < list.length; i++)
			{
				var k:* = list[i];
				delete dic[k];
			}
			
			return list.length;
		}
		
		/**
		 * 删除字典内所有的键/值引用
		 * @param dic 字典对象
		 * 
		 */		
		public static function delAll(dic:Dictionary):void
		{
			var list:Array = getKeys(dic);
			
			for each(var key:* in list)
			{
				delete dic[key];
			}
		}
	}
}