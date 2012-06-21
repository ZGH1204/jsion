package core.events
{
	import flash.events.Event;
	
	public class StartEvent extends Event
	{
		/**
		 * 游戏基础库加载并初始化后触发。
		 */		
		public static const INITIALIZED:String = "initialized";
		
		public function StartEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}