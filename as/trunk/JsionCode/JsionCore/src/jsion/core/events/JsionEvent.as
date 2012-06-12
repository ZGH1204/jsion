package jsion.core.events
{
	import flash.events.Event;
	
	public class JsionEvent extends Event
	{
		public static const COMPLETE:String = "complete";
		
		public static const ERROR:String = "error";
		
		public static const CHANGED:String = "changed";
		
		public function JsionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}