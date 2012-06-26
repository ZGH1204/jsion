package knightage.net.packets.build
{
	import knightage.net.LogicPacket;
	
	public class CreateBuildingPacket extends LogicPacket
	{
		public function CreateBuildingPacket()
		{
			super(PacketCodes.CreateBuilding);
		}
		
		public var buildType:int;
		
		override public function writeData():void
		{
			writeShort(buildType);
		}
	}
}