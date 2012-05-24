package jsion
{
	/**
	 * 列表
	 * @author Jsion
	 * 
	 */	
	public class List implements IList, IDispose
	{
//		public static const CASEINSENSITIVE		:int=1;
//		public static const DESCENDING 			:int=2;
//		public static const UNIQUESORT 			:int=4;
//		public static const RETURNINDEXEDARRAY 	:int=8;
//		public static const NUMERIC  	  		  	:int=16;
		
		/**
		 * @private
		 */		
		protected var _elements:Array;
		
		public function List()
		{
			_elements = [];
		}
		
		/**
		 * 获取指定索引位置的对象
		 * @param index 要获取的索引位置
		 * @return 
		 * 
		 */		
		public function get(index:int):*
		{
			if(index >= _elements.length) return null;
			
			return _elements[index];
		}
		
		/**
		 * 将指定对象插入到指定的索引位置
		 * @param element 要插入的对象
		 * @param index 要插入的索引位置
		 * 
		 */		
		public function add(element:*, index:int = -1):void
		{
			if(index < 0)
				_elements.push(element);
			else
				_elements.splice(index, 0, element);
		}
		
		/**
		 * 将指定列表内的对象从指定索引位置开始依次插入
		 * @param eList 要插入的对象列表
		 * @param startIndex 要插入的起始索引位置
		 * 
		 */		
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
		
		/**
		 * 将指定列表内的对象从指定索引位置开始依次插入
		 * @param lst 要插入的对象列表
		 * @param startIndex 要插入的起始索引位置
		 * 
		 */		
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
		
		/**
		 * 对列表内的对象进行排序 使用Array.sort()方法
		 * @param compare 一个用来确定数组元素排序顺序的比较函数。比较函数应该用两个参数进行比较。 给定元素 A 和 B，compareFunction 的结果可以具有负值、0 或正值： 
		 * <ul>
		 * 		<li>若返回值为负，则表示 A 在排序后的序列中出现在 B 之前。</li>
		 * 		<li>若返回值为 0，则表示 A 和 B 具有相同的排序顺序。</li>
		 * 		<li>若返回值为正，则表示 A 在排序后的序列中出现在 B 之后。</li>
		 * </ul>
		 * @param options 一个或多个数字或定义的常量，相互之间由 |（按位 OR）运算符隔开，它们将排序的行为从默认行为更改为其它行为。 此参数是可选的。 下面是 sortOptions 可接受的值：
		 * <ul>
		 * <li>1 或 Array.CASEINSENSITIVE</li>
		 * <li>2 或 Array.DESCENDING</li>
		 * <li>4 或 Array.UNIQUESORT</li>
		 * <li>8 或 Array.RETURNINDEXEDARRAY</li>
		 * <li>16 或 Array.NUMERIC</li>
		 * </ul>
		 * @return 返回值取决于您是否传递任何参数，如以下列表中所述：
		 * <ul>
		 * <li>如果为 ...args 参数的 sortOptions 变量指定值 4 或 Array.UNIQUESORT，并且所排序的两个或更多个元素具有相同的排序字段，则 Flash 返回值 0 并且不修改数组。</li>
		 * <li>如果为 ...args 参数的 sortOptions 变量指定值 8 或 Array.RETURNINDEXEDARRAY，则 Flash 返回排序后的索引数值数组以反映排序结果，并且不修改数组。 </li>
		 * <li>否则，Flash 不返回任何内容并修改该数组以反映排序顺序。</li>
		 * </ul>
		 */		
		public function sort(compare:Object, options:int):Array{
			return _elements.sort(compare, options);
		}
		
		/**
		 * 根据列表中的对象的一个或多个字段对列表中的对象进行排序 使用Array.sortOn()方法
		 * @param key 一个字符串，它标识要用作排序值的字段，或一个数组，其中的第一个元素表示主排序字段，第二个元素表示第二排序字段，依此类推。 
		 * @param options 所定义常量的一个或多个数字或名称，相互之间由 bitwise OR (|) 运算符隔开，它们可以更改排序行为。 options 参数可接受以下值：
		 * <ul>
		 * 	<li>Array.CASEINSENSITIVE 或 1</li>
		 * 	<li>Array.DESCENDING 或 2</li>
		 * 	<li>Array.UNIQUESORT 或 4</li>
		 * 	<li>Array.RETURNINDEXEDARRAY 或 8</li>
		 * 	<li>Array.NUMERIC 或 16</li>
		 * </ul>
		 * @return 返回值取决于您是否传递任何参数：
		 * <ul>
		 * 	<li>如果您为 options 参数指定值 4 或 Array.UNIQUESORT，并且要排序的两个或多个元素具有相同的排序字段，则返回值 0 并且不修改数组。 </li>
		 * 	<li>如果为 options 参数指定值 8 或 Array.RETURNINDEXEDARRAY，则返回反映排序结果的数组并且不修改数组。</li>
		 * 	<li>否则，不返回任何结果并修改该数组以反映排序顺序。</li>
		 * </ul>
		 */		
		public function sortOn(key:Object, options:int):Array{
			return _elements.sortOn(key, options);
		}
		
		/**
		 * 克隆对象
		 */		
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
		
		/**
		 * 释放资源
		 */		
		public function dispose():void
		{
			if(_elements)
			{
				_elements.splice(0);
				_elements = null;
			}
		}
		
		/**
		 * 对象的字符串形式
		 */		
		public function toString():String{
			return "List : " + _elements.toString();
		}
	}
}