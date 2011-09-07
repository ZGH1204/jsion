package jcomponent.org.events
{
	import flash.events.Event;
	
	public class ScrollBarEvent extends Event
	{
		public static const STATE_CHANGED:String = "stateChanged";
		
		public function ScrollBarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}