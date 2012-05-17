package jsion.events
{
	import flash.events.Event;
	
	public class DisplayEvent extends Event
	{
		public static const PROPERTIES_CHANGED:String = "propertiesChanged";
		
		public var data:*;
		
		public function DisplayEvent(type:String, data:* = null)
		{
			super(type);
			
			this.data = data;
		}
		
		override public function clone():Event
		{
			return new DisplayEvent(type, data);
		}
	}
}