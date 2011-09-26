package jsion.core.messages
{
	public interface IMsgReceiver
	{
		function get id():String;
		
		/**
		 * 注册指定消息响应函数
		 * @param msg 消息标识
		 * @param handlerFn 带一个Message参数的处理函数
		 */		
		function registeHandler(msg:uint, handlerFn:Function):void;
		
		/**
		 * 注册接收指定全局消息
		 * @param msg 消息标识
		 * @param handlerFn 带一个Message参数的处理函数
		 */		
		function registeReceive(msg:uint, handlerFn:Function):void;
		
		/**
		 * 同步接收消息
		 * @param msg 消息体
		 * @return 消息附加返回对象
		 */		
		function receiveSync(msg:Msg):*;
		
		/**
		 * 异步接收消息
		 * @param msg 消息体
		 */		
		function receiveAsync(msg:Msg):void;
	}
}