package knightage.net.packets.tavern
{
	import knightage.net.LogicPacket;
	
	public class PartyPacket extends LogicPacket
	{
		public function PartyPacket()
		{
			super(PacketCodes.Party);
		}
		
		/**
		 * 派对类型。其可能的值为：
		 * <ul>
		 * 	<li>1：表示普通派对</li>
		 * 	<li>2：表示豪华派对</li>
		 * </ul>
		 */		
		public var partyType:int;
		
		override public function writeData():void
		{
			writeByte(partyType);
		}
	}
}