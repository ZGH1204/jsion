package jsion.events
{
	import flash.events.Event;
	
	public class DisplayEvent extends Event
	{
		public static const PROPERTIES_CHANGED:String = "propertiesChanged";
		public static const CHANGED:String = "changed";
		public static const MULTIPLE_SELECTE_CHANGED:String = "multipleSelectChanged";
		public static const SELECT_CHANGED:String = "selectChanged";
		
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