package jsion.core.messages
{
	import flash.utils.Dictionary;

	public class MsgMonitor
	{
		private static var monitor:MsgMonitorImp = new MsgMonitorImp();
		
		/**
		 * 注册指定消息的接收者
		 * @param msg 消息标识
		 * @param receiver 接收者
		 * 
		 */		
		public static function registeMsgReceiver(msg:uint, receiver:IMsgReceiver):void
		{
			monitor.registeMsgReceiver(msg, receiver);
		}
		
		/**
		 * 移除指定消息的接收者
		 * @param msg 消息标识
		 * @param receiver 接收者
		 * 
		 */		
		public static function removeMsgReceiver(msg:uint, receiver:IMsgReceiver):void
		{
			monitor.removeMsgReceiver(msg, receiver);
		}
		
		/**
		 * 注册消息接收者
		 * @param id 接收者标识
		 * @param receiver 接收者对象
		 * 
		 */		
		public static function registeReceiver(receiver:IMsgReceiver):void
		{
			monitor.registeReceiver(receiver);
		}
		
		/**
		 * 注册消息接收者
		 * @param id 接收者标识
		 * 
		 */		
		public static function removeReceiver(id:String):IMsgReceiver
		{
			return monitor.removeReceiver(id);
		}
		
		/**
		 * 同步发送消息
		 * @param msg 消息体
		 * @return 所有接收者的返回对象字典列表
		 * 
		 */		
		public static function sendMessage(msg:Msg):Dictionary
		{
			return monitor.sendMessage(msg);
		}
		
		/**
		 * 异步发送消息
		 * @param msg 消息体
		 * 
		 */		
		public static function postMessage(msg:Msg):void
		{
			monitor.postMessage(msg);
		}
		
		/**
		 * 创建消息对象
		 * @param msg 消息标识
		 * @param sender 发送者
		 * @param receivers 接收列表
		 * @param wParam 消息参数
		 * @param lParam 消息参数
		 * @return 消息对象
		 * 
		 */		
		public static function createMsg(msg:uint, sender:String, receivers:Array = null, wParam:Object = null, lParam:Object = null):Msg
		{
			return monitor.createMsg(msg, sender, receivers, wParam, lParam);
		}
		
		/**
		 * 创建并且同步发送消息对象
		 * @param msg 消息标识
		 * @param sender 发送者
		 * @param receivers 接收列表
		 * @param wParam 消息参数
		 * @param lParam 消息参数
		 * @return 所有接收者的返回对象字典列表，其中"SendedMsg"指示已发送过的消息对象。
		 * 
		 */		
		public static function createAndSendMsg(msg:uint, sender:String, receivers:Array = null, wParam:Object = null, lParam:Object = null):Dictionary
		{
			return monitor.createAndSendMsg(msg, sender, receivers, wParam, lParam);
		}
		
		/**
		 * 创建并且异步发送消息对象
		 * @param msg 消息标识
		 * @param sender 发送者
		 * @param receivers 接收列表
		 * @param wParam 消息参数
		 * @param lParam 消息参数
		 * @return 已发送的消息对象
		 */		
		public static function createAndPostMsg(msg:uint, sender:String, receivers:Array = null, wParam:Object = null, lParam:Object = null):Msg
		{
			return monitor.createAndPostMsg(msg, sender, receivers, wParam, lParam);
		}
	}
}