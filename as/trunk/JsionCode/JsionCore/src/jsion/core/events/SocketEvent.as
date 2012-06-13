package jsion.core.events
{
	import flash.events.Event;
	
	public class SocketEvent extends Event
	{
		/**
		 * Socket通信出错时派发
		 */		
		public static const ERROR:String = "error";
		
		/**
		 * Socket连接成功时派发
		 */		
		public static const CONNECTED:String = "connected";
		
		/**
		 * Socket连接关闭时派发
		 */		
		public static const CLOSED:String = "closed";
		
		/**
		 * Socket接收到数据时派发
		 */		
		public static const RECEIVED:String = "received";
		
		/**
		 * Socket发送数据错误时派发
		 */		
		public static const SEND_ERROR:String = "sendError";
		
		/**
		 * 数据处理出错时派发
		 */		
		public static const HANDLE_ERROR:String = "handleError";
		
		protected var _eData:*;
		
		/**
		 * 事件数据
		 */		
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