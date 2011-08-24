package jui.org.events
{
	public class InteractiveEvent extends JEvent
	{
		public static const STATE_CHANGED:String = "stateChanged";
		
		public static const SELECTION_CHANGED:String = "selectionChanged";
		
		public static const SCROLL_CHANGED:String = "scrollChanged";
		
		public function InteractiveEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}