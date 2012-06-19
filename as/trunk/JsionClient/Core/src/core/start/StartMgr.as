package core.start
{
	import flash.events.Event;
	
	import jsion.events.JsionEventDispatcher;

	public class StartMgr
	{
		private static var dispatcher:JsionEventDispatcher = new JsionEventDispatcher();
		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public static function dispatchEvent(event:Event):Boolean
		{
			return dispatcher.dispatchEvent(event);
		}
		
		public static function hasEventListener(type:String):Boolean
		{
			return dispatcher.hasEventListener(type);
		}
		
		public static function willTrigger(type:String):Boolean
		{
			return dispatcher.willTrigger(type);
		}
		
		public static function removeAllEventListener():void
		{
			dispatcher.removeAllEventListeners();
		}
	}
}