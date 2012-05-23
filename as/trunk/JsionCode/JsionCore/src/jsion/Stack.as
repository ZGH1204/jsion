package jsion
{
	/**
	 * 栈
	 * @author Jsion
	 * 
	 */	
	public class Stack extends List implements IStack
	{
		public function Stack()
		{
			super();
		}
		
		/**
		 * 获取栈顶对象 但不出栈
		 */		
		public function peek():*
		{
			if(count == 0) return null;
			return _elements[count - 1];
		}
		
		/**
		 * 出栈 取出栈顶对象
		 */		
		public function pop():*
		{
			if(count == 0) return null;
			return _elements.pop();
		}
		
		/**
		 * 将指定对象压入栈顶
		 * @param element 要入栈的对象
		 * 
		 */		
		public function push(element:*):void
		{
			if(_elements == null) _elements = [];
			
			_elements.push(element);
		}
		
		/**
		 * 查找指定对象 并返回索引位置
		 * @param o 要查找的对象
		 * @return 在栈中的索引位置
		 * 
		 */		
		public function search(o:*):int
		{
			var index:int = indexOf(o);
			if(index >= 0) index -= count;
			return index;
		}
	}
}