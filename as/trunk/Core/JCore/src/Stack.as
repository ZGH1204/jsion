package
{
	public class Stack extends List implements IStack
	{
		public function Stack()
		{
			super();
		}
		
		public function peek():*
		{
			if(count == 0) return null;
			return _elements[count - 1];
		}
		
		public function pop():*
		{
			if(count == 0) return null;
			return _elements.pop();
		}
		
		public function push(element:*):void
		{
			if(_elements == null) _elements = [];
			
			_elements.push(element);
		}
		
		public function search(o:*):int
		{
			var index:int = indexOf(o);
			if(index >= 0) index -= count;
			return index;
		}
	}
}