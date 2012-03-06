package knightage.core.net.handlers
{
	import knightage.core.net.IPacketHandler;
	import knightage.core.net.KPacket;
	import knightage.core.net.PacketCodes;
	import knightage.core.net.SocketProxy;
	
	public class KitPlayerHandler implements IPacketHandler
	{
		public function KitPlayerHandler()
		{
		}
		
		public function get code():int
		{
			return PacketCodes.KitPlayer;
		}
		
		public function handle(pkg:KPacket):void
		{
			SocketProxy.close();
			
			t("被踢下线");
		}
	}
}