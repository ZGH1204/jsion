package gs.events
{
	import flash.events.Event;

	public class TweenEvent extends Event
	{
        public var position:Number = 0;
        public var time:Number = 0;
        
        public static const MOTION_START:String = "motionStart";
        public static const MOTION_STOP:String = "motionStop";
		public static const MOTION_CHANGE:String = "motionChange";
		public static const MOTION_FINISH:String = "motionFinish";
		
		public function TweenEvent(type:String, $time:Number, $pos:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
            this.time = $time;
            this.position = $pos;
		}
		
		override public function clone() : Event
        {
            return new TweenEvent(this.type, this.time, this.position, this.bubbles, this.cancelable);
        }
	}
}