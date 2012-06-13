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
		
		/**
		 * 设置节点数据
		 */		
		public function setData(data:*):void
		{
			this.data = data;
		}
		
		/**
		 * 获取节点数据
		 */		
		public function getData():*
		{
			return data;
		}
		
		/**
		 * 设置前驱节点
		 */		
		public function setPrevNode(preNode:ListNode):void
		{
			this.preNode = preNode;
		}
		
		/**
		 * 获取前驱节点
		 */		
		public function getPrevNode():ListNode
		{
			return preNode;
		}
		
		/**
		 * 设置后续节点
		 */		
		public function setNextNode(nextNode:ListNode):void
		{
			this.nextNode = nextNode;
		}
		
		/**
		 * 获取后续节点
		 */		
		public function getNextNode():ListNode
		{
			return nextNode;
		}
		
		/**
		 * 对象的字符串形式
		 */		
		public function toString():String{
			return "ListNode[data:" + data + "]";
		}
	}
}