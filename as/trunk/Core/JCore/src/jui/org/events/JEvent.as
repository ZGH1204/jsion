package jui.org.events
{
	import flash.events.Event;
	
	public class JEvent extends Event
	{
		public static const SHOWN:String = "shown";
		
		public static const HIDDEN:String = "hidden";
		
		public function JEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new JEvent(type, bubbles, cancelable);
		}
	}
}