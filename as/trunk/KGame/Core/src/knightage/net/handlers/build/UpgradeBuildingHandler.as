package knightage.net.handlers.build
{
	import core.net.GamePacket;
	import core.net.IPacketHandler;
	
	import knightage.StaticConfig;
	import knightage.mgrs.PlayerMgr;
	
	public class UpgradeBuildingHandler implements IPacketHandler
	{
		public function UpgradeBuildingHandler()
		{
		}
		
		public function get code():int
		{
			return PacketCodes.UpgradeBuilding;
		}
		
		public function handle(pkg:GamePacket):void
		{
			var buildType:int  = pkg.readUnsignedByte();
			var templateID:int = pkg.readInt();
			var coins:int = pkg.readInt();
			var exp:int = pkg.readInt();
			
			PlayerMgr.subPlayerCoin(coins);
			PlayerMgr.subPlayerExp(exp);
			PlayerMgr.updateBuildTID(buildType, templateID);
		}
	}
}