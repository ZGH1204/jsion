package knightage.core.net
{
	import jsion.core.messages.MsgMonitor;
	
	import knightage.core.ModuleType;
	import knightage.core.MsgFlag;
	

	public class SocketProxy
	{
		private static const SocketSender:String = "SocketProxy";
		private static const SocketReceiver:Array = [ModuleType.K_SOCKET];
		
		public function SocketProxy()
		{
		}
		
		public static function connect(ip:String, port:int):void
		{
			postMsg(MsgFlag.SocketConnect, ip, port);
		}
		
		public static function forceConnect(ip:String, port:int):void
		{
			postMsg(MsgFlag.SocketForceConnect, ip, port);
		}
		
		public static function send(pkg:SLGPacket):void
		{
			postMsg(MsgFlag.SocketSend, pkg);
		}
		
		private static function postMsg(msg:uint, wParam:Object = null, lParam:Object = null):void
		{
			MsgMonitor.createAndPostMsg(msg, SocketSender, SocketReceiver, wParam, lParam);
		}
		
		private static function sendMsg(msg:uint, wParam:Object = null, lParam:Object = null):void
		{
			MsgMonitor.createAndSendMsg(msg, SocketSender, SocketReceiver, wParam, lParam);
		}
		
		public static function setPacketClass(cls:Class):void
		{
			sendMsg(MsgFlag.SocketSetPacketClass, cls);
		}
	}
}