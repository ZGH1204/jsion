package jcomponent.org.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ReleaseEvent extends MouseEvent
	{
		public static const RELEASE:String = "release";
		
		public static const RELEASE_OUT_SIDE:String = "releaseOutSide";
		
		
		private var releasedOutSide:Boolean;
		
		
		public function ReleaseEvent(type:String, releasedOutSide:Boolean, e:MouseEvent)
		{
			super(type, false, false, e.localX, e.localY, e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown, e.delta);
			
			this.releasedOutSide = releasedOutSide;
		}
		
		public function isReleasedOutSide():Boolean
		{
			return releasedOutSide;
		}
		
		override public function clone():Event
		{
			return new ReleaseEvent(type, isReleasedOutSide(), this);
		}
	}
}