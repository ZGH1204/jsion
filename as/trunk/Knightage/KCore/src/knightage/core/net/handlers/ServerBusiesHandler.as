package knightage.core.net.handlers
{
	import knightage.core.net.IPacketHandler;
	import knightage.core.net.PacketCodes;
	import knightage.core.net.SLGPacket;
	
	public class ServerBusiesHandler implements IPacketHandler
	{
		public function ServerBusiesHandler()
		{
		}
		
		public function get code():int
		{
			return PacketCodes.ServerBusies;
		}
		
		public function handle(pkg:SLGPacket):void
		{
			t("服务器繁忙");
		}
	}
}