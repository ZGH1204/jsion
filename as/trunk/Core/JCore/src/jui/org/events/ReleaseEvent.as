package jui.org.events
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ReleaseEvent extends MouseEvent
	{
		public static const RELEASE:String = "release";
		
		public static const RELEASE_OUT_SIDE:String = "releaseOutSide";	
		
		
		private var _pressTarget:DisplayObject;
		private var _releasedOutSide:Boolean;
		
		
		public function ReleaseEvent(type:String, pressTarget:DisplayObject, releasedOutSide:Boolean, e:MouseEvent)
		{
			super(type, false, false, e.localX, e.localY, e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown, e.delta);
		}
		
		public function get pressTarget():DisplayObject
		{
			return _pressTarget;
		}
		
		public function get releasedOutSide():Boolean
		{
			return _releasedOutSide;
		}
		
		override public function clone():Event
		{
			return new ReleaseEvent(type, pressTarget, releasedOutSide, this);
		}
	}
}