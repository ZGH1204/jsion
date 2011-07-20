package jsocket.events
{
	import flash.events.Event;
	
	public class SocketEvent extends Event
	{
		public static const ERROR:String = "error";
		public static const CONNECTED:String = "connected";
		public static const CLOSED:String = "closed";
		public static const RECEIVED:String = "received";
		
		public static const SEND_ERROR:String = "sendError";
		public static const HANDLE_ERROR:String = "handleError";
		
		protected var _eData:*;
		
		public function get eData():*
		{
			return _eData;
		}
		
		public function SocketEvent(type:String, eData:* = null)
		{
			super(type);
			_eData = eData;
		}
		
		override public function clone():Event
		{
			return new SocketEvent(type, eData);
		}
		
		override public function toString():String
		{
			return "[SocketEvent] Type: " + type;
		}
	}
}