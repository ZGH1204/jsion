package jsion
{
	import flash.utils.Dictionary;
	
	import jsion.utils.*;
	
	/**
	 * 哈希表
	 * @author Jsion
	 * 
	 */	
	public class HashSet implements IDispose
	{
		private var container:Dictionary;
		private var length:int;
		
		public function HashSet()
		{
			container = new Dictionary();
			length = 0;
		}
		
		/**
		 * 哈希表长度
		 */		
		public function size():int
		{
			return length;
		}
		
		/**
		 * 指示是否包含指定值
		 * @param o
		 */		
		public function contains(o:*):Boolean
		{
			return container[o] !== undefined;
		}
		
		/**
		 * 插入指定值
		 * @param o
		 */		
		public function add(o:*):void
		{
			if(!contains(o))
			{
				length++;
			}
			container[o] = o;
		}
		
		/**
		 * 指示哈希表是否为空
		 */		
		public function isEmpty():Boolean
		{
			return length == 0;
		}
		
		/**
		 * 移除指定值，并返回一个指示是否包含指定值的结果。
		 * @param o
		 */		
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
		
		/**
		 * 移除并释放哈希表中的所有数据
		 */		
		public function clear():void
		{
			DisposeUtil.free(container);
			length = 0;
		}
		
		/**
		 * 将指定数组的所有数据插入哈希表中
		 * @param arr
		 */		
		public function addAll(arr:Array):void
		{
			for each(var i:* in arr)
			{
				add(i);
			}
		}
		
		/**
		 * 移除哈希表中的所有数据
		 */		
		public function removeAll():void
		{
			DictionaryUtil.delAll(container);
			length = 0;
		}
		
		/**
		 * 将指定数组中的项从哈希表中移除
		 * @param arr
		 */		
		public function removeAllByList(arr:Array):void
		{
			for each(var i:* in arr)
			{
				remove(i);
			}
		}
		
		/**
		 * 指示指定数组中的所有项是否包含于哈希表中
		 * @param arr
		 */		
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
		
		/**
		 * 以哈希表中的每个值为参数执行遍历函数[func(value)]
		 * @param func 拥有一个参数的遍历函数
		 */		
		public function eachFn(func:Function):void
		{
			for each(var i:* in container)
			{
				func(i);
			}
		}
		
		/**
		 * 将哈希表转换为数组的形式
		 * @return 
		 */		
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
		
		/**
		 * 释放资源
		 */		
		public function dispose():void
		{
			removeAll();
			container = null;
		}
	}
}