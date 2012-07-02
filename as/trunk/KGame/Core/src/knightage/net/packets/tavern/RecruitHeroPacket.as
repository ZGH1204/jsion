package knightage.net.packets.tavern
{
	import knightage.net.LogicPacket;
	
	public class RecruitHeroPacket extends LogicPacket
	{
		public function RecruitHeroPacket(code:int=0)
		{
			super(code);
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