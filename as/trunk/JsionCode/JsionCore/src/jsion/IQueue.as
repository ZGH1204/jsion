package jsion
{
	/**
	 * 队列接口
	 * @author Jsion
	 * 
	 */	
	public interface IQueue extends IList
	{
		/**
		 * 将指定对象追加到列表末尾(入列)
		 * @param element 要追加到列表末尾的对象
		 * 
		 */		
		function enQueue(element:*):void;
		
		/**
		 * 将数组 <code>eList</code> 中的对象按顺序追加到列表末尾
		 * @param eList 要追加至列表末尾的数组对象
		 * 
		 */		
		function enQueueAll(eList:Array):void;
		/**
		 * 将列表 <code>lst</code> 中的对象按顺序追加到列表末尾
		 * @param lst 要追加至列表末尾的列表对象
		 * 
		 */		
		function enQueueList(lst:IList):void;
		
		/**
		 * 删除并返回列表中的第一个对象,列表中的其他对象的索引位置依次前移一个位置.(出列)
		 * @return 列表中的第一个对象
		 */		
		function deQueue():*;
	}
}