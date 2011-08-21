package jui.org.events
{
	import flash.events.Event;

	public class ResizedEvent extends JEvent
	{
		public static const RESIZED:String = "resized";
		
		private var _oldSize:IntDimension;
		private var _newSize:IntDimension;
		
		public function ResizedEvent(type:String, oldSize:IntDimension, newSize:IntDimension)
		{
			super(type, false, false);
			_oldSize = oldSize;
			_newSize = newSize;
		}
		
		public function get oldSize():IntDimension
		{
			return _oldSize;
		}
		
		public function get newSize():IntDimension
		{
			return _newSize;
		}
		
		override public function clone():Event
		{
			return new ResizedEvent(type, _oldSize, _newSize);
		}
	}
}