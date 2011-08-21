package
{
	public class List implements IList, IDispose
	{
		public static const CASEINSENSITIVE		:int=1;
		public static const DESCENDING 			:int=2;
		public static const UNIQUESORT 			:int=4;
		public static const RETURNINDEXEDARRAY 	:int=8;	
		public static const NUMERIC  	  		  	:int=16;	
		
		protected var _elements:Array;
		
		public function List()
		{
			_elements = [];
		}
		
		public function get(index:int):*
		{
			return _elements[index];
		}
		
		public function add(element:*, index:int = -1):void
		{
			if(index < 0)
				_elements.push(element);
			else
				_elements.splice(index, 0, element);
		}
		
		public function addAll(eList:Array, startIndex:int = -1):void
		{
			if(eList == null || eList.length == 0) return;
			
			if(startIndex < 0 || startIndex == _elements.length)
			{
				_elements = _elements.concat(eList);
			}
			else if(startIndex == 0)
			{
				_elements = eList.concat(_elements);
			}
			else
			{
				var right:Array = _elements.splice(startIndex);
				_elements = _elements.concat(eList);
				_elements = _elements.concat(right);
			}
		}
		
		public function addList(lst:IList, startIndex:int = -1):void
		{
			addAll(lst.toArray(), startIndex);
		}
		
		/**
		 * 将列表中指定的位置的对象替换为指定对象
		 * @param index 要替换的指定位置
		 * @param element 要替换的指定对象
		 * @return 被替换掉的对象
		 */		
		public function replaceAt(index:int, element:*):*
		{
			if(index < 0 || index >= count) return null;
			
			var oldVal:* = _elements[index];
			_elements[index] = element;
			return oldVal;
		}
		
		/**
		 * 设置列表中指定的位置的对象为指定对象
		 * @param index 要替换的指定位置
		 * @param element 要替换的指定对象
		 * @return 被放弃掉的对象
		 */		
		public function setElementAt(index:int, element:*):*
		{
			replaceAt(index, element);
		}
		
		/**
		 * 从列表中删除指定对象
		 * @param element 要删除的指定对象
		 * @return 被删除的对象
		 */		
		public function remove(element:*):*
		{
			var index:int = indexOf(element);
			if(index > -1)
				return removeAt(index);
			else
				return null;
		}
		
		/**
		 * 从列表中删除指定位置的对象
		 * @param index 要删除的索引位置
		 * @return 被删除的对象
		 */		
		public function removeAt(index:int):*
		{
			if(index < 0 || index >= count) return null;
			
			var tmp:* = _elements[index];
			_elements.splice(index, 1);
			return tmp;
		}
		
		/**
		 * 删除指定范围内的对象
		 * @param fromIndex 指定范围的起始索引位置
		 * @param toIndex 指定范围的结束索引位置
		 * @return 被删除的对象数组
		 */		
		public function removeRange(fromIndex:int, toIndex:int):Array
		{
			fromIndex = Math.max(0, fromIndex);
			toIndex = Math.min(toIndex, _elements.length - 1);
			
			if(fromIndex > toIndex) return [];
			else return _elements.splice(fromIndex, toIndex - fromIndex + 1);
		}
		
		/**
		 * 获取指定对象在列表中的第一个索引位置(从0开始的索引位置),当不存在指定对象时返回-1
		 * @param element 要获取索引位置的对象
		 * @return 第一个的索引位置
		 */		
		public function indexOf(element:*):int
		{
			for(var i:int = 0; i<_elements.length; i++){
				if(_elements[i] === element){
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * 获取指定对象在列表中的最后一个索引位置(从0开始的索引位置),当不存在指定对象时返回-1
		 * @param element 要获取索引位置的对象
		 * @return 最后一个的索引位置
		 */		
		public function lastIndexOf(element:*):int
		{
			for(var i:int = _elements.length - 1; i >= 0; i--){
				if(_elements[i] === element){
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * 获取列表中是否包含指定对象
		 * @param element 指定对象
		 * @return 列表中是否包含指定对象
		 */		
		public function contains(element:*):Boolean
		{
			return indexOf(element) >= 0;
		}
		
		/**
		 * 获取列表中的第一个对象
		 * @return 列表中的第一个对象
		 */		
		public function first():*
		{
			return _elements[0];
		}
		
		/**
		 * 获取列表中的最后一个对象
		 * @return 列表中的最后一个对象
		 */		
		public function last():*
		{
			return _elements[_elements.length-1];
		}
		
		/**
		 * 清除列表
		 */		
		public function clear():void
		{
			if(isEmpty() == false)
			{
				_elements.splice(0);
				_elements = [];
			}
		}
		
		/**
		 * 返回当前列表是否为空
		 */		
		public function isEmpty():Boolean
		{
			if(_elements && _elements.length>0)
				return false;
			else
				return true;
		}
		
		/**
		 * 转换为数组
		 */		
		public function toArray():Array
		{
			return _elements.concat();
		}
		
		/**
		 * 从指定的起始位置开始删除指定个数的元素
		 */		
		public function subtract(startIndex:int, length:int):Array
		{
			return _elements.slice(startIndex, Math.min(startIndex + length, count));
		}
		
		public function sort(compare:Object, options:int):Array{
			return _elements.sort(compare, options);
		}
		
		public function sortOn(key:Object, options:int):Array{
			return _elements.sortOn(key, options);
		}
		
		public function clone():List{
			var cloned:List = new List();
			for (var i:int=0; i<_elements.length; i++){
				cloned.add(_elements[i]);
			}		
			return cloned;
		}
		
		/**
		 * 列表个数
		 */		
		public function get count():int
		{
			if(_elements == null) return 0;
			return _elements.length;
		}
		
		/**
		 * 把对列表中的每个对象当做 <code>fn</code> 的第一个参数,并执行 <code>fn</code> 函数
		 * @param fn 对每个对象执行的函数
		 * 
		 */		
		public function each(fn:Function):void
		{
			for each(var val:* in _elements)
			{
				fn(val);
			}
		}
		
		public function dispose():void
		{
			if(_elements)
			{
				_elements.splice(0);
				_elements = null;
			}
		}
		
		public function toString():String{
			return "List : " + _elements.toString();
		}
	}
}