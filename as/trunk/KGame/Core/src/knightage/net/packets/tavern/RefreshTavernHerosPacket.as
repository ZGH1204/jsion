package knightage.net.packets.tavern
{
	import knightage.net.LogicPacket;
	
	public class RefreshTavernHerosPacket extends LogicPacket
	{
		public function RefreshTavernHerosPacket()
		{
			super(PacketCodes.RefreshTavernHeros);
		}
		
		public var pid:int;
		
		override public function writeData():void
		{
			writeInt(pid);
		}
	}
}