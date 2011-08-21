package
{
	import flash.utils.Dictionary;
	
	import jutils.org.util.DictionaryUtil;
	import jutils.org.util.DisposeUtil;

	public class HashMap implements IDispose
	{
		private var length:int;
		private var content:Dictionary;
		
		public function HashMap()
		{
			length = 0;
			content = new Dictionary();
		}
		
		public function get size():int
		{
			return length;
		}
		
		public function isEmpty():Boolean
		{
			return (length == 0);
		}
		
		public function getKeys():Array
		{
			var tmp:Array = [];
			for(var key:* in content)
			{
				tmp.push(key);
			}
			return tmp;
		}
		
		public function getValues():Array
		{
			var tmp:Array = [];
			for each(var val:* in content)
			{
				tmp.push(val);
			}
			return tmp;
		}
		
		public function eachKey(fn:Function):void
		{
			if(fn == null) return;
			for(var key:* in content)
			{
				fn(key);
			}
		}
		
		public function eachValue(fn:Function):void
		{
			if(fn == null) return;
			for each(var val:* in content)
			{
				fn(val);
			}
		}
		
		public function containsKey(key:*):Boolean
		{
			return (content[key] != undefined);
		}
		
		public function containsValue(value:*):Boolean
		{
			for each(var val:* in content)
			{
				if(val === value) return true;
			}
			return false;
		}
		
		public function get(key:*):*
		{
			return content[key];
		}
		
		public function getValue(key:*):*
		{
			return get(key);
		}
		
		public function getKey(value:*):*
		{
			for(var key:* in content)
			{
				if(content[key] == value) return key;
			}
			return null;
		}
		
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
				var exists:Boolean = containsKey(key);
				if(exists == false) length++;
				var oldVal:* = get(key);
				content[key] = value;
				return oldVal;
			}
		}
		
		public function remove(key:*):*
		{
			if(containsKey(key) == false) return null;
			
			var temp:* = content[key];
			delete content[key];
			length--;
			return temp;
		}
		
		public function removeValue(value:*):*
		{
			var temp:* = null;
			for(var key:* in content)
			{
				if(content[key] == value)
				{
					temp = content[key];
					delete content[key];
					length--;
					break;
				}
			}
			return temp;
		}
		
		public function removeAll():void
		{
			var keys:Array = DictionaryUtil.getKeys(content);
			for each(var key:* in keys)
			{
				delete content[key];
			}
		}
		
		public function clear():void
		{
			length = 0;
			content = new Dictionary();
		}
		
		public function clone():HashMap
		{
			var temp:HashMap = new HashMap();
			for(var key:* in content)
			{
				temp.put(key, content[key]);
			}
			return temp;
		}
		
		public function dispose():void
		{
			DisposeUtil.free(content);
			content = null;
		}
		
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