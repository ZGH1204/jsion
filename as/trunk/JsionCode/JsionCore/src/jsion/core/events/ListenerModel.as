package jsion.core.events
{
	import jsion.IDispose;

	/**
	 * 事件监听信息
	 * @author Jsion
	 */	
	public class ListenerModel implements IDispose
	{
		/**
		 * 事件类型
		 */		
		public var type:String;
		
		/**
		 * 事件的侦听器函数列表
		 */		
		public var listener:Array;
		
		/**
		 * 指示侦听器是运行于捕获阶段、目标阶段还是冒泡阶段。
		 * 如果将 useCapture 设置为 true，则侦听器只在捕获阶段处理事件，而不在目标或冒泡阶段处理事件。 
		 * 如果 useCapture 为 false，则侦听器只在目标或冒泡阶段处理事件。 
		 * 若要在所有三个阶段都侦听事件，请调用两次 addEventListener，一次将 useCapture 设置为 true，第二次再将 useCapture 设置为 false。
		 */		
		public var useCapture:Boolean;
		
		/**
		 * 释放资源
		 */		
		public function dispose():void
		{
			if(listener) listener.splice(0);
			listener = null;
		}
	}
}