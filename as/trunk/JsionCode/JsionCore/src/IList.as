package
{
	public interface IList
	{
		/**
		 * 返回当前列表中指定位置的对象
		 * @param index 列表中的位置
		 * @return 列表中指定位置的对象<br>
		 * 如果指定位置超出列表索引范围(index < 0 || index >= count)则返回undefined
		 * 
		 */		
		function get(index:int):*;
		
		/**
		 * 在列表中的指定位置 <code>index</code> 处插入指定对象,使对象在列表中的索引位置为index
		 * @param element 要插入的对象
		 * @param index 插入列表的索引位置
		 * 
		 */		
		function add(element:*, index:int = -1):void;
		
		/**
		 * 从列表的指定位置 <code>startIndex</code> 处开始,将数组 <code>eList</code> 中的对象按顺序插入到列表中
		 * @param eList 要插入的数组对象
		 * @param startIndex 插入列表中的起始索引位置
		 * 
		 */		
		function addAll(eList:Array, startIndex:int = -1):void;
		
		/**
		 * 从列表的指定位置 <code>startIndex</code> 处开始,将列表 <code>eList</code> 中的对象按顺序插入到列表中
		 * @param lst 要插入的列表对象
		 * @param startIndex 插入列表中的起始索引位置
		 * 
		 */		
		function addList(lst:IList, startIndex:int = -1):void;
		
		/**
		 * 将列表中指定的位置的对象替换为指定对象
		 * @param index 要替换的指定位置
		 * @param element 要替换的指定对象
		 * @return 被替换掉的对象
		 */		
		function replaceAt(index:int, element:*):*;
		
		/**
		 * 设置列表中指定的位置的对象为指定对象
		 * @param index 要替换的指定位置
		 * @param element 要替换的指定对象
		 * @return 被放弃掉的对象
		 */		
		function setElementAt(index:int, element:*):*;
		
		/**
		 * 从列表中删除指定对象
		 * @param element 要删除的指定对象
		 * @return 被删除的对象
		 */		
		function remove(element:*):*;
		
		/**
		 * 从列表中删除指定位置的对象
		 * @param index 要删除的索引位置
		 * @return 被删除的对象
		 */		
		function removeAt(index:int):*;
		
		/**
		 * 删除指定范围内的对象
		 * @param fromIndex 指定范围的起始索引位置
		 * @param toIndex 指定范围的结束索引位置
		 * @return 被删除的对象数组
		 */		
		function removeRange(fromIndex:int, toIndex:int):Array;
		
		/**
		 * 获取指定对象在列表中的第一个索引位置(从0开始的索引位置),当不存在指定对象时返回-1
		 * @param element 要获取索引位置的对象
		 * @return 第一个的索引位置
		 */		
		function indexOf(element:*):int;
		
		/**
		 * 获取指定对象在列表中的最后一个索引位置(从0开始的索引位置),当不存在指定对象时返回-1
		 * @param element 要获取索引位置的对象
		 * @return 最后一个的索引位置
		 */		
		function lastIndexOf(element:*):int;
		
		/**
		 * 获取列表中是否包含指定对象
		 * @param element 指定对象
		 * @return 列表中是否包含指定对象
		 */		
		function contains(element:*):Boolean;
		
		/**
		 * 获取列表中的第一个对象
		 * @return 列表中的第一个对象
		 */		
		function first():*;
		
		/**
		 * 获取列表中的最后一个对象
		 * @return 列表中的最后一个对象
		 */		
		function last():*;
		
		/**
		 * 清除列表
		 */		
		function clear():void;
		
		/**
		 * 返回当前列表是否为空
		 */		
		function isEmpty():Boolean;
		
		/**
		 * 转换为数组
		 */		
		function toArray():Array;
		
		/**
		 * 从指定的起始位置开始删除指定个数的元素
		 * @param startIndex 起始位置
		 * @param length 指定个数
		 */		
		function subtract(startIndex:int, length:int):Array;
		
		/**
		 * 列表个数
		 */		
		function get count():int;
		
		/**
		 * 把对列表中的每个对象当做 <code>fn</code> 的第一个参数,并执行 <code>fn</code> 函数
		 * @param fn 对每个对象执行的函数
		 * 
		 */		
		function each(fn:Function):void;
	}
}