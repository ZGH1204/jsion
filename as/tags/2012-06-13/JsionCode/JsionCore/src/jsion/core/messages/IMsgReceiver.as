package jsion.core.messages
{
	/**
	 * 消息接收者接口
	 * @author Jsion
	 * 
	 */	
	public interface IMsgReceiver
	{
		/**
		 * 接收者ID
		 */		
		function get id():String;
		
		/**
		 * 注册当前接收者处理指定消息的函数
		 * @param msg 消息标识
		 * @param handlerFn 以 Msg 对象为参数的处理函数
		 */		
		function registeHandler(msg:uint, handlerFn:Function):void;
		
		/**
		 * 移除当前接收者已注册的消息处理函数
		 * @param msg 消息标识
		 */		
		function removeHandler(msg:uint):Function;
		
		/**
		 * 注册指定全局消息在当前接收者中的处理函数
		 * @param msg 消息标识
		 * @param handlerFn 以 Msg 对象为参数的处理函数
		 */		
		function registeReceive(msg:uint, handlerFn:Function):void;
		
		/**
		 * 移除全局消息处理函数
		 * @param msg 消息标识
		 */		
		function removeReceive(msg:uint):Function;
		
		/**
		 * 同步接收消息
		 * @param msg 消息对象
		 * @return 消息附加返回对象
		 */		
		function receiveSync(msg:Msg):*;
		
		/**
		 * 异步接收消息，并在下帧时处理消息。
		 * @param msg 消息对象
		 */		
		function receiveAsync(msg:Msg):void;
	}
}