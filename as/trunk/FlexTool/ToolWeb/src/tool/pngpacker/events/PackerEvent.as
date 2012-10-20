package tool.pngpacker.events
{
	import flash.events.Event;
	
	import jsion.IDispose;
	
	public class PackerEvent extends Event implements IDispose
	{
		public static const TEXT_CHANGED:String = "textChanged";
		
		public static const CREATE_ACTION:String = "createAction";
		
		public var data:*;
		
		public function PackerEvent(type:String, data:* = null)
		{
			super(type);
			
			this.data = data;
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			data = null;
		}
		
	}
}