package jsion.comps.events
{
	import flash.events.Event;
	
	public class UIEvent extends Event
	{
		public static const DRAW:String = "draw";
		
		public static const RESIZE:String = "resize";
		
		public static const CHANGE:String = "change";
		
		public function UIEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}