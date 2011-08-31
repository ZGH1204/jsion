package jui.org.events
{
	import flash.events.Event;
	
	import jutils.org.util.StringUtil;

	public class ReleaseEvent extends UIEvent
	{
		public static const RELEASE:String = "release";
		
		public static const RELEASE_OUT_SIDE:String = "releaseOutSide";
		
		public var isOutSide:Boolean;
		
		public function ReleaseEvent(type:String, isOutSide:Boolean)
		{
			super(type);
			
			this.isOutSide = isOutSide;
		}
		
		override public function clone():Event
		{
			return new ReleaseEvent(type, isOutSide);
		}
	}
}