package knightage.net.packets.build
{
	import knightage.net.LogicPacket;
	
	public class UpgradeBuildingPacket extends LogicPacket
	{
		public function UpgradeBuildingPacket()
		{
			super(PacketCodes.UpgradeBuilding);
		}
		
		public var buildType:int;
		
		override public function writeData():void
		{
			writeByte(buildType);
		}
	}
}