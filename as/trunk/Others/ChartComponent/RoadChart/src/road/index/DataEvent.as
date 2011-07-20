package road.index
{
	import flash.events.Event;

	public class DataEvent extends Event
	{
		public var data:Object;
        public static const NEWS_LOADED:String = "newsDataLoaded";
        public static const INDEXES_LOADED:String = "indexesDataLoaded";
        public static const ERROR:String = "dataError";

		public function DataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone() : Event
        {
            var de:DataEvent = new DataEvent(type, bubbles, cancelable);
            de.data = data;
            return de;
        }

        override public function toString() : String
        {
            return formatToString("DataEvent", "type", "bubbles", "cancelable");
        }
	}
}