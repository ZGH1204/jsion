package knightage.net.packets.tavern
{
	import knightage.net.LogicPacket;
	
	public class PartyPacket extends LogicPacket
	{
		public function PartyPacket()
		{
			super(PacketCodes.Party);
		}
		
		override public function writeData():void
		{
			
		}
	}
}