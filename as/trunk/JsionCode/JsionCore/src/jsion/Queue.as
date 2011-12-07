package jsion
{
	public class Queue extends List implements IQueue
	{
		public function Queue()
		{
			super();
		}
		
		public function enQueue(element:*):void
		{
			add(element);
		}
		
		public function enQueueAll(eList:Array):void
		{
			addAll(eList);
		}
		
		public function enQueueList(lst:IList):void
		{
			addList(lst);
		}
		
		public function deQueue():*
		{
			return _elements.shift();
		}
	}
}