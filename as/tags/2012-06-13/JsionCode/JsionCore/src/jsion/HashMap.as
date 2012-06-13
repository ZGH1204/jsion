package jsion
{
	import flash.utils.Dictionary;
	
	import jsion.utils.*;
	
	/**
	 * 提供键/值对的哈希表
	 * @author Jsion
	 * 
	 */	
	public class HashMap implements IDispose
	{
		private var length:int;
		private var content:Dictionary;
		
		public function HashMap()
		{
			length = 0;
			content = new Dictionary();
		}
		
		/**
		 * 哈希表长度
		 */		
		public function get size():int
		{
			return length;
		}
		
		/**
		 * 指示哈希表是否为空
		 */		
		public function isEmpty():Boolean
		{
			return (length == 0);
		}
		
		/**
		 * 获取哈希表中所有的Key
		 */		
		public function getKeys():Array
		{
			var tmp:Array = [];
			for(var key:* in content)
			{
				tmp.push(key);
			}
			return tmp;
		}
		
		/**
		 * 获取哈希表中所有的Value
		 */		
		public function getValues():Array
		{
			var tmp:Array = [];
			for each(var val:* in content)
			{
				tmp.push(val);
			}
			return tmp;
		}
		
		/**
		 * 对哈希表中的所有key执行指定函数[fn(key)]
		 * @param fn 拥有一个参数的遍历函数
		 */		
		public function eachKey(fn:Function):void
		{
			if(fn == null) return;
			for(var key:* in content)
			{
				fn(key);
			}
		}
		
		/**
		 * 对哈希表中的所有value执行指定函数[fn(value)]
		 * @param fn 拥有一个参数的遍历函数
		 */		
		public function eachValue(fn:Function):void
		{
			if(fn == null) return;
			for each(var val:* in content)
			{
				fn(val);
			}
		}
		
		/**
		 * 指示哈希表中是否包含指定key的项
		 * @param key
		 */		
		public function containsKey(key:*):Boolean
		{
			return (content[key] != undefined);
		}
		
		/**
		 * 指示哈希表中是否包含指定的value
		 * @param value
		 */		
		public function containsValue(value:*):Boolean
		{
			for each(var val:* in content)
			{
				if(val === value) return true;
			}
			return false;
		}
		
		/**
		 * 获取指定key的项
		 * @param key
		 */		
		public function get(key:*):*
		{
			return content[key];
		}
		
		/**
		 * 获取指定key的项,与get(key)相同.
		 * @param key
		 */		
		public function getValue(key:*):*
		{
			return get(key);
		}
		
		/**
		 * 获取指定项的key
		 * @param value
		 */		
		public function getKey(value:*):*
		{
			for(var key:* in content)
			{
				if(content[key] == value) return key;
			}
			return null;
		}
		
		/**
		 * 插入一个键/值对数据
		 * @param key
		 * @param value
		 */		
		public function put(key:*, value:*):*
		{
			if(key == null)
			{
				throw new ArgumentError("参数key不能为null或undefined");
				return;
			}
			else if(value == null)
			{
				return remove(key);
			}
			else
			{
				var oldVal:* = null
				var exists:Boolean = containsKey(key);
				if(exists == false)
				{
					length++;
				}
				else
				{
					oldVal = get(key);
				}
				content[key] = value;
				return oldVal;
			}
		}
		
		/**
		 * 移除指定key的项，并返回移除的项。
		 * @param key
		 */		
		public function remove(key:*):*
		{
			if(containsKey(key) == false) return null;
			
			var temp:* = content[key];
			delete content[key];
			length--;
			return temp;
		}
		
		/**
		 * 移除指定的项，并返回对应的key。
		 * @param value
		 */		
		public function removeValue(value:*):*
		{
			var temp:* = null;
			for(var key:* in content)
			{
				if(content[key] == value)
				{
					temp = key;
					delete content[key];
					length--;
					break;
				}
			}
			return temp;
		}
		
		/**
		 * 移除哈希表中的所有数据，不对数据项进行释放操作。
		 */		
		public function removeAll():void
		{
//			var keys:Array = DictionaryUtil.getKeys(content);
//			for each(var key:* in keys)
//			{
//				delete content[key];
//			}
			
			DictionaryUtil.delAll(content);
			
			length = 0;
		}
		
		/**
		 * 移除哈希表中的所有数据，并对数据项进行释放操作。
		 */		
		public function clear():void
		{
			DisposeUtil.free(content);
			length = 0;
			//content = new Dictionary();
		}
		
		/**
		 * 对哈希表进行浅复制
		 */		
		public function clone():HashMap
		{
			var temp:HashMap = new HashMap();
			for(var key:* in content)
			{
				temp.put(key, content[key]);
			}
			return temp;
		}
		
		/**
		 * 释放哈希表
		 */		
		public function dispose():void
		{
			DisposeUtil.free(content);
			content = null;
		}
		
		/**
		 * 获取字符串形式
		 */		
		public function toString():String{
			var ks:Array = getKeys();
			var vs:Array = getValues();
			var temp:String = "HashMap Content:\n";
			for(var i:int=0; i<ks.length; i++)
			{
				temp += ks[i]+" -> "+vs[i] + "\n";
			}
			return temp;
		}
	}
}