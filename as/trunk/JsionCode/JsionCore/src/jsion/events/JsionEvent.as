package jsion.events
{
	import flash.events.Event;
	
	public class JsionEvent extends Event
	{
		public static const COMPLETE:String = "complete";
		
		public static const ERROR:String = "error";
		
		public static const CHANGED:String = "changed";
		
		public static const CANCEL:String = "cancel";
		
		public static const TOTAL_BYTES:String = "totalBytes";
		
		public function JsionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}