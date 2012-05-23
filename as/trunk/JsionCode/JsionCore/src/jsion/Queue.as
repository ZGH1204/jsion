package jsion
{
	/**
	 * 队列
	 * @author Jsion
	 * 
	 */	
	public class Queue extends List implements IQueue
	{
		public function Queue()
		{
			super();
		}
		
		/**
		 * 将一个对象附加到队列末尾
		 * @param element
		 * 
		 */		
		public function enQueue(element:*):void
		{
			add(element);
		}
		
		/**
		 * 将一个列表内的所有对象依次附加到队列末尾
		 * @param eList 要附加的对象列表
		 * 
		 */		
		public function enQueueAll(eList:Array):void
		{
			addAll(eList);
		}
		
		/**
		 * 将一个列表内的所有对象依次附加到队列末尾
		 * @param eList 要附加的对象列表
		 * 
		 */		
		public function enQueueList(lst:IList):void
		{
			addList(lst);
		}
		
		/**
		 * 取出队列的第一个对象
		 */		
		public function deQueue():*
		{
			return _elements.shift();
		}
	}
}