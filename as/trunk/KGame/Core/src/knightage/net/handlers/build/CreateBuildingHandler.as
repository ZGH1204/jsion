package knightage.net.handlers.build
{
	import core.net.GamePacket;
	import core.net.IPacketHandler;
	
	import knightage.mgrs.PlayerMgr;
	
	public class CreateBuildingHandler implements IPacketHandler
	{
		public function CreateBuildingHandler()
		{
		}
		
		public function get code():int
		{
			return PacketCodes.CreateBuilding;
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
				PlayerMgr.updateBuildTID(buildType, templateID);
				PlayerMgr.updatePlayerCoin(coins);
				PlayerMgr.updatePlayerExp(exp);
			}
			else
			{
				trace("结果类型未处理：", rlt);
			}
		}
	}
}