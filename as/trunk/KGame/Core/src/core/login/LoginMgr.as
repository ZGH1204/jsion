package core.login
{
	import flash.events.Event;
	
	import jsion.events.JsionEventDispatcher;

	public class LoginMgr
	{
		private static var dispatcher:JsionEventDispatcher = new JsionEventDispatcher();
		
		public static var account:String;
		
		public static var cryptString:String;
		
		public static var logined:Boolean;
		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public static function dispatchEvent(event:Event):void
		{
			dispatcher.dispatchEvent(event);
		}
		
		public static function removeAllEventListeners():void
		{
			dispatcher.removeAllEventListeners();
		}
	}
}