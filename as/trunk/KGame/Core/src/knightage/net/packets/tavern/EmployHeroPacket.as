package knightage.net.packets.tavern
{
	import knightage.net.LogicPacket;
	
	public class EmployHeroPacket extends LogicPacket
	{
		public function EmployHeroPacket()
		{
			super(PacketCodes.EmployHero);
		}
		
		/**
		 * 有效值：1、2、3。
		 */		
		public var index:int;
		
		override public function writeData():void
		{
			writeByte(index);
		}
	}
}