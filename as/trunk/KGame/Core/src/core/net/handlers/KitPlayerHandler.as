package core.net.handlers
{
	import core.net.GamePacket;
	import core.net.IPacketHandler;
	import core.net.SocketProxy;

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
			
			//t("被踢下线");
		}
	}
}