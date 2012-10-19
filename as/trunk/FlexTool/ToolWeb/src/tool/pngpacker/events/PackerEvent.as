package tool.pngpacker.events
{
	import flash.events.Event;
	
	public class PackerEvent extends Event
	{
		public static const TEXT_CHANGED:String = "textChanged";
		
		public function PackerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}