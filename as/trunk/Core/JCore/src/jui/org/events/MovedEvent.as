package jui.org.events
{
	import flash.events.Event;

	public class MovedEvent extends JEvent
	{
		public static const MOVED:String = "moved";
		
		private var _oldPos:IntPoint;
		private var _newPos:IntPoint;
		
		public function MovedEvent(type:String, oldPos:IntPoint, newPos:IntPoint)
		{
			super(type, false, false);
			this._oldPos = oldPos;
			this._newPos = newPos;
		}
		
		override public function clone():Event
		{
			return new MovedEvent(type, _oldPos, _newPos);
		}
		
		public function get oldPos():IntPoint
		{
			return _oldPos;
		}
		
		public function get newPos():IntPoint
		{
			return _newPos;
		}
	}
}