package jcore.org.action
{
	public class Action implements IDispose
	{
		internal var isPrepared:Boolean;
		
		internal var isFinished:Boolean;
		
		/**
		 * 指示当前对象是否已准备
		 */		
		public function get prepared():Boolean
		{
			return isPrepared;
		}
		
		/**
		 * 指示当前对象是否已完成
		 */		
		public function get finished():Boolean
		{
			return isFinished;
		}
		
		/**
		 * 连接两个Action，释放参数act。
		 * @param act 新的Action
		 * @return true时释放参数act对象，并且不加入Action队列;false则反之。
		 * 
		 */		
		public function connect(act:Action):Boolean
		{
			return false;
		}
		
		/**
		 * 指示是否可替换队列中当前的Action对象为参数act对象。
		 * @param act 新的Action
		 * @return true时替换当前的Action对象为参数act对象，并且释放掉当前的Action对象。
		 * 
		 */		
		public function replace(act:Action):Boolean
		{
			return false;
		}
		
		/**
		 * 准备阶段，仅执行一次。
		 */		
		public function prepare():void
		{
			
		}
		
		/**
		 * 执行中，直接到设置isFinished为true后将执行finish()方法完成并释放当前Action对象。
		 */		
		public function execute():void
		{
			isFinished = true;
		}
		
		/**
		 * 立即执行
		 */		
		public function executeAtOnce():void
		{
			isFinished = true;
		}
		
		/**
		 * 完成阶段
		 */		
		public function finish():void
		{
			
		}
		
		/**
		 * 释放Action
		 */		
		public function dispose():void
		{
			
		}
	}
}