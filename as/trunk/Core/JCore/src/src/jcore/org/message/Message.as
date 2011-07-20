package jcore.org.message
{
	public class Message
	{
		/**
		 * 消息的发送者
		 */		
		public var sender:String;
		
		/**
		 * 消息的接收者ID列表
		 */		
		public var receivers:Array = [];
		
		/**
		 * 消息标识符，由一个数值来表示。
		 */		
		public var msg:uint;
		
		/**
		 * 消息附加的参数
		 */		
		public var wParam:Object;
		
		/**
		 * 消息附加的参数
		 */		
		public var lParam:Object;
		
		/**
		 * 消息发送的时刻，getTimer()获取。
		 */		
		public var time:int;
	}
}