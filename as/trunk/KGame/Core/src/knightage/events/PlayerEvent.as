package knightage.events
{
	import flash.events.Event;
	
	import jsion.IDispose;
	
	public class PlayerEvent extends Event implements IDispose
	{
		public static const BUILD_UPGRADE:String = "buildUpgrade";
		
		public var data:*;
		
		public function PlayerEvent(type:String, data:*)
		{
			this.data = data;
			
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new PlayerEvent(type, data);
		}
		
		public function dispose():void
		{
			data = null;
		}
	}
}