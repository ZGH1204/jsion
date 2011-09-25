package
{
	import flash.utils.Dictionary;
	
	import jsion.utils.*;

	public class HashSet implements IDispose
	{
		private var container:Dictionary;
		private var length:int;
		
		public function HashSet()
		{
			container = new Dictionary();
			length = 0;
		}
		
		public function size():int
		{
			return length;
		}
		
		public function contains(o:*):Boolean
		{
			return container[o] !== undefined;
		}
		
		public function add(o:*):void
		{
			if(!contains(o))
			{
				length++;
			}
			container[o] = o;
		}
		
		public function isEmpty():Boolean
		{
			return length == 0;
		}
		
		public function remove(o:*):Boolean
		{
			if(contains(o))
			{
				delete container[o];
				length--;
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function clear():void
		{
			var list:Array = DictionaryUtil.getKeys(container);
			for each(var o:* in list)
			{
				DictionaryUtil.delKey(container, o);
			}
			length = 0;
		}
		
		public function addAll(arr:Array):void
		{
			for each(var i:* in arr)
			{
				add(i);
			}
		}
		
		public function removeAll(arr:Array):void
		{
			for each(var i:* in arr)
			{
				remove(i);
			}
		}
		
		public function containsAll(arr:Array):Boolean
		{
			for(var i:int=0; i<arr.length; i++)
			{
				if(!contains(arr[i]))
				{
					return false;
				}
			}
			return true;
		}
		
		public function eachFn(func:Function):void
		{
			for each(var i:* in container)
			{
				func(i);
			}
		}
		
		public function toArray():Array
		{
			var arr:Array = new Array(length);
			var index:int = 0;
			for each(var i:* in container)
			{
				arr[index] = i;
				index ++;
			}
			return arr;
		}
		
		public function dispose():void
		{
			clear();
			container = null;
		}
	}
}