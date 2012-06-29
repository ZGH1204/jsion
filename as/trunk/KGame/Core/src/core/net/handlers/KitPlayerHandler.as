package core.net.handlers
{
	import core.net.GamePacket;
	import core.net.IPacketHandler;
	import core.net.SocketProxy;
	
	import jsion.debug.DEBUG;
	
	import knightage.display.Alert;

	public class KitPlayerHandler implements IPacketHandler
	{
		public function KitPlayerHandler()
		{
		}
		
		public function get code():int
		{
			return PacketCodes.KitPlayer;
		}
		
		public function handle(pkg:GamePacket):void
		{
			SocketProxy.close();
			
			Alert.show("被迫下线，您的帐号已在其他地方登陆。", false, kitCallback, Alert.OK, null, null, false);
			//t("被踢下线");
		}
		
		private function kitCallback():void
		{
			DEBUG.debug("跳转到登陆页");
		}
	}
}