package jsion.utils
{
	/**
	 * 数组工具
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public final class ArrayUtil
	{
		/**
		 * 创建一个指定初始长度的数组
		 * @param len 要创建的数组长度
		 * @return 指定长度的数组
		 * 
		 */		
		public static function create(len:int):Array
		{
			var array:Array = [];
			
			array.length = len;
			
			return array;
		}
		
		/**
		 * 将任意个数组连接，并过滤掉重复项，返回新数组(仅适合引用对象)。
		 * @param args 数组或对象
		 * @return 连接后的数组
		 * 
		 */		
		public static function contact(...args):Array
		{
			if(args == null || args.length == 0)
				return null;
			
			var result:Array = [];
			
			for(var i:uint = 0; i < args.length; i++)
			{
				if(args[i] is Array)
				{
					for(var j:uint = 0; j < args[i].length; j++)
					{
						if(result.indexOf(args[i][j]) == -1)
							result.push(args[i][j]);
					}
				}
				else
				{
					if(result.indexOf(args[i] == -1))
						result.push(args[i]);
				}
			}
			
			return result;
		}
		
		/**
		 * 指示当前数组中是否存在指定对象
		 * @param array 数组对象
		 * @param value 要查找的对象
		 * @return true表示存在，false表示不存在。
		 * 
		 */		
		public static function containsValue(array:Array, value:*):Boolean
		{
			return array && array.indexOf(value) != -1;
		}
		
		/**
		 * 克隆指定数组为新数组
		 * @param array 要克隆的数组
		 * @return 克隆后的新数组
		 * 
		 */		
		public static function clone(array:Array):Array
		{
			return array.concat();
		}
		
		/**
		 * 将指定对象放入到数组末尾，如果数组中存在则不放。
		 * @param array 数组对象
		 * @param obj 要放入的对象
		 * @return 数组中已存在时返回-1，否则返回指定对象的索引。
		 */		
		public static function push(array:Array, obj:Object):int
		{
			if(array && array.indexOf(obj) == -1)
			{
				array.push(obj);
				return array.length - 1;
			}
			
			return -1;
		}
		
		/**
		 * 将指定对象放入到数组的指定位置，如果数组中存在则不放。
		 * @param array 数组对象
		 * @param obj 要放入的对象
		 * @param index 指定的索引位置
		 * @return 数组中已存在时返回-1，否则返回指定对象的索引。
		 * 
		 */		
		public static function insert(array:Array, obj:Object, index:int):int
		{
			if(index < 0)
			{
				return push(array, obj);
			}
			
			if(index >= array.length)
			{
				return push(array, obj);
			}
			
			array.splice(index, 0, obj);
			
			return index;
		}
		
		/**
		 * 移除数组中的指定对象
		 * @param array 数组对象
		 * @param obj 要移除的对象
		 * @return 移除个数
		 * 
		 */		
		public static function remove(array:Array, obj:*):int
		{
			if(array == null) return 0;
			
			var index:int = array.indexOf(obj);
			
			if(index == -1) return 0;
			
			var list:Array = array.splice(index, 1);
			
			return list ? list.length : 0;
		}
		
		/**
		 * 移除数组中指定索引位置的对象
		 * @param array 数组对象
		 * @param index 索引位置
		 * @return 移除的对象
		 * 
		 */		
		public static function removeAt(array:Array, index:int):*
		{
			if(index < 0 || index >= array.length) return null;
			
			var obj:* = array[index];
			
			array.splice(index, 1);
			
			return obj;
		}
		
		/**
		 * 移除数组中的所有对象
		 * @param array 数组对象
		 * 
		 */		
		public static function removeAll(array:Array):void
		{
			if(array == null || array.length == 0) return;
			
			array.length = 0;
			//array.splice(0);
		}
		
		/**
		 * 获取数组中从指定的起始索引(包含)到结束索引(包含)之间的所有对象并构造一个新数组，不会对原数组进行任何修改。
		 * @param array 要搜索的数组
		 * @param startIndex 从0开始的起始索引
		 * @param endIndex 从0开始的结束索引
		 */		
		public static function getRange(array:Array, startIndex:int, endIndex:int):Array
		{
			if(array == null || startIndex < 0 || endIndex >= array.length) return null;
			
			var list:Array = [];
			
			for(var i:int = startIndex; i <= endIndex; i++)
			{
				list.push(array[i]);
			}
			
			return list;
		}
		
		/**
		 * 以数字格式降序排列指定字段
		 * @param array 要排序的数组
		 * @param key 排序字段
		 * 
		 */		
		public static function sortDescByNum(array:Array, key:String):void
		{
			array.sortOn(key, Array.DESCENDING | Array.NUMERIC);
		}
		
		/**
		 * 以数字格式升序排列指定字段
		 * @param array 要排序的数组
		 * @param key 排序字段
		 * 
		 */		
		public static function sortAscByNum(array:Array, key:String):void
		{
			array.sortOn(key, Array.NUMERIC);
		}
	}
}