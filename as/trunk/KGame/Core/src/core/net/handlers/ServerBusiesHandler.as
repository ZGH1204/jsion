package core.net.handlers
{
	import core.net.GamePacket;
	import core.net.IPacketHandler;
	
	import jsion.debug.DEBUG;

	public class ServerBusiesHandler implements IPacketHandler
	{
		public function ServerBusiesHandler()
		{
		}
		
		public function get code():int
		{
			return PacketCodes.ServerBusies;
		}
		
		public function handle(pkg:GamePacket):void
		{
			DEBUG.debug("服务器繁忙");
		}
	}
}