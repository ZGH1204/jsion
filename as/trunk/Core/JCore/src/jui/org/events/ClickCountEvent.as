package jui.org.events
{
	import flash.events.Event;
	
	public class ClickCountEvent extends JEvent
	{
		public static const CLICK_COUNT:String = "clickCount";
		
		private var _count:int;
		
		public function ClickCountEvent(type:String, count:int, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_count = count;
		}
		
		public function get count():int
		{
			return _count;
		}
		
		override public function clone():Event
		{
			return new ClickCountEvent(type, count, bubbles, cancelable);
		}
	}
}