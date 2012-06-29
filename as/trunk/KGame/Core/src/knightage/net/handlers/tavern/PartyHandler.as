package knightage.net.handlers.tavern
{
	import core.net.GamePacket;
	import core.net.IPacketHandler;
	
	public class PartyHandler implements IPacketHandler
	{
		public function PartyHandler()
		{
		}
		
		public function get code():int
		{
			return PacketCodes.Party;
		}
		
		public function handle(pkg:GamePacket):void
		{
		}
	}
}