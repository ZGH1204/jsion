package knightage.core
{
	import flash.utils.Dictionary;
	
	import jsion.core.messages.IMsgReceiver;
	import jsion.core.messages.MsgMonitor;

	public class MsgProxy
	{
		public static const MSG_SENDER:String = "MsgMonitorProxy";
		
		public function MsgProxy()
		{
		}
		
		public static function createAndSendMsg(msg:uint, receivers:Array = null, wParam:Object = null, lParam:Object = null):Dictionary
		{
			return MsgMonitor.createAndSendMsg(msg, MSG_SENDER, receivers, wParam, lParam);
		}
		
		public static function createAndPostMsg(msg:uint, receivers:Array = null, wParam:Object = null, lParam:Object = null):void
		{
			MsgMonitor.createAndPostMsg(msg, MSG_SENDER, receivers, wParam, lParam);
		}
		
		public static function registeMsgReceiver(msg:uint, receiver:IMsgReceiver):void
		{
			MsgMonitor.registeMsgReceiver(msg, receiver);
		}
	}
}