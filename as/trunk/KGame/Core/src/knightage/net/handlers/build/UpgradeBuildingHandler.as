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
			var rlt:int = pkg.readUnsignedByte();
			var buildType:int  = pkg.readShort();
			var templateID:int = pkg.readInt();
			var coins:int = pkg.readInt();
			var exp:int = pkg.readInt();
			
			if(rlt == 1)
			{
				PlayerMgr.updatePlayerCoin(coins);
				PlayerMgr.updatePlayerExp(exp);
				PlayerMgr.updateBuildTID(buildType, templateID);
			}
			else
			{
				trace("结果类型未处理：", rlt);
			}
		}
	}
}