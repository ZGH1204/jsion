package jcomponent.org.events
{
	import flash.events.Event;
	
	public class ButtonEvent extends Event
	{
		public static const ACTION:String = "act";
		
		public static const STATE_CHANGED:String = "stateChanged";
		
		public static const SELECTION_CHANGED:String = "selectionChanged";
		
		public function ButtonEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}