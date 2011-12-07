package jsion
{
	/**
	 * 双向链表
	 * @author Jsion
	 * 
	 */	
	public class ListNode
	{
		private var data:*;
		
		private var nextNode:ListNode;
		
		private var preNode:ListNode;
		
		public function ListNode(data:*, preNode:ListNode , nextNode:ListNode)
		{
			this.data = data;
			this.preNode = preNode;
			this.nextNode = nextNode;
		}
		
		public function setData(data:*):void
		{
			this.data = data;
		}
		
		public function getData():*
		{
			return data;
		}
		
		public function setPrevNode(preNode:ListNode):void
		{
			this.preNode = preNode;
		}
		
		public function getPrevNode():ListNode
		{
			return preNode;
		}
		
		public function setNextNode(nextNode:ListNode):void
		{
			this.nextNode = nextNode;
		}
		
		public function getNextNode():ListNode
		{
			return nextNode;
		}
		
		public function toString():String{
			return "ListNode[data:" + data + "]";
		}
	}
}