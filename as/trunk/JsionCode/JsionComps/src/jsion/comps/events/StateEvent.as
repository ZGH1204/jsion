package jsion.comps.events
{
	import flash.events.Event;
	
	public class StateEvent extends Event
	{
		public static const STATE_CHANGED:String = "stateChanged";
		
		public static const SELECTION_CHANGED:String = "selectionChanged";
		
		public function StateEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}