package jsion.events
{
	import flash.events.MouseEvent;
	
	public class ReleaseEvent extends MouseEvent
	{
		public static const RELEASE:String = "release";
		
		public static const RELEASE_OUT_SIDE:String = "releaseOutSide";
		
		private var releasedOutSide:Boolean;
		
		public function ReleaseEvent(type:String, releasedOutSide:Boolean, e:MouseEvent)
		{
			this.releasedOutSide = releasedOutSide;
			
			super(type, false, false, e.localX, e.localY, e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown, e.delta);
		}
	}
}