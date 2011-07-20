package road.v.events
{
	import flash.events.Event;

	public class ItemEvent extends Event
	{
		public var index:int;
        public static const ITEM_OVER:String = "item_over";
        public static const ITEM_OUT:String = "item_out";
        public static const ITEM_CLICK:String = "item_click";

		public function ItemEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var ie:ItemEvent = new ItemEvent(type,bubbles, cancelable);
			ie.index = index;
			return ie;
		}
		
		override public function toString():String
		{
			return formatToString("ItemEvent", "type", "bubbles", "cancelable");
		}
	}
}