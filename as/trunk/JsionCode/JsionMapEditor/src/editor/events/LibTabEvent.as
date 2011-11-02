package editor.events
{
	import flash.events.Event;
	
	public class LibTabEvent extends Event
	{
		public static const SELECT_FILE:String = "selectFile";
		
		public static const DOUBLE_CLICK:String = "itemDoubleClick";
		
		public var filename:String;
		
		public var obj:Object;
		
		public function LibTabEvent(type:String, filename:String, obj:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.filename = filename;
			
			this.obj = obj;
			
			super(type, bubbles, cancelable);
		}
	}
}