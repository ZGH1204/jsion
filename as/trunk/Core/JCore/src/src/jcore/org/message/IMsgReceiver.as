package jcore.org.message
{
	public interface IMsgReceiver
	{
		function get id():String;
		
		/**
		 * 指示是否允许接收当前消息
		 */		
		function allowReceived(msg:Message):Boolean;
		
		/**
		 * 同步接收消息
		 * @param msg 消息体
		 * @return 消息附加返回对象
		 * 
		 */		
		function receiveSync(msg:Message):Object;
		
		/**
		 * 异步接收消息
		 * @param msg 消息体
		 * 
		 */		
		function receiveAsync(msg:Message):void;
	}
}